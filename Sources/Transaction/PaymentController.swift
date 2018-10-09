import Vapor

public final class PaymentController<Provider>: RouteCollection where
    Provider: PaymentMethod, Provider.Purchase: Parameter, Provider.Purchase.ResolvedParameter == Future<Provider.Purchase>,
    Provider.Payment: Codable, Provider.ExecutionData: Content
{
    public let root: String?
    public let structure: RouteStructure
    
    public init(root: String? = nil, structure: RouteStructure) {
        self.root = root
        self.structure = structure
    }
    
    public func boot(router: Router) throws {
        let payments = router.grouped(root ?? "", Provider.slug)
        
        switch self.structure {
        case .mixed:
            payments.post(Provider.ExecutionData.self, use: run)
        case .separate:
            payments.post("create", use: create)
            payments.post(Provider.ExecutionData.self, at: "execute", use: execute)
        }
    }
    
    public func create(_ request: Request)throws -> Future<Response> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let payment = purchase.flatMap(provider.payment)
        
        if let responder = payment as? Future<CreatedPaymentResponse> {
            return responder.flatMap { $0.created(request) }
        } else {
            let response = request.response()
            return payment.map(response.content.encode).transform(to: response)
        }
    }
    
    public func execute(_ request: Request, body: Provider.ExecutionData)throws -> Future<Response> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let payment = purchase.flatMap { $0.fetchPayment(on: request) }
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        if let responder = executed as? Future<ExecutedPaymentResponse> {
            return responder.flatMap { $0.executed(request) }
        } else {
            let response = request.response()
            return executed.map(response.content.encode).transform(to: response)
        }
    }
    
    func run(_ request: Request, body: Provider.ExecutionData)throws -> Future<Response> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let payment = purchase.flatMap(provider.payment)
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        if let responder = executed as? Future<ExecutedPaymentResponse> {
            return responder.flatMap { $0.executed(request) }
        } else {
            let response = request.response()
            return executed.map(response.content.encode).transform(to: response)
        }
    }
}

public protocol CreatedPaymentResponse {
    func created(_ request: Request) -> Future<Response>
}

public protocol ExecutedPaymentResponse {
    func executed(_ request: Request) -> Future<Response>
}

public enum RouteStructure {
    case mixed
    case separate
}
