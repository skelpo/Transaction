import Vapor


// MARK: - PaymentController
public final class PaymentController<Provider>: RouteCollection where
    Provider: PaymentMethod & PaymentResponse, Provider.Purchase: Parameter, Provider.Purchase.ResolvedParameter == Future<Provider.Purchase>,
    Provider.Payment: Codable, Provider.ExecutionData: Content
{
    public let structure: RouteStructure
    
    public init(structure: RouteStructure) {
        self.structure = structure
    }
    
    public func boot(router: Router) throws {
        let payments = router.grouped(Provider.slug)
        
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
        
        let response = request.response()
        let payment = purchase.flatMap(provider.payment)
        
        return payment.flatMap(provider.created).map(response.content.encode).transform(to: response)
    }
    
    public func execute(_ request: Request, body: Provider.ExecutionData)throws -> Future<Response> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let response = request.response()
        let payment = purchase.flatMap { $0.fetchPayment(on: request) }
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        return executed.flatMap(provider.executed).map(response.content.encode).transform(to: response)
    }
    
    func run(_ request: Request, body: Provider.ExecutionData)throws -> Future<Response> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let response = request.response()
        let payment = purchase.flatMap(provider.payment)
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        return executed.flatMap(provider.executed).map(response.content.encode).transform(to: response)
    }
}


// MARK: - Protocols
public typealias PaymentResponse = CreatedPaymentResponse & ExecutedPaymentResponse

public protocol CreatedPaymentResponse: PaymentMethod {
    associatedtype CreatedResponse: Content = Self.Payment
    
    func created(from payment: Payment) -> Future<CreatedResponse>
}

public protocol ExecutedPaymentResponse: PaymentMethod {
    associatedtype ExecutedResponse: Content = Self.Payment
    
    func executed(from payment: Payment) -> Future<ExecutedResponse>
}

extension CreatedPaymentResponse where CreatedResponse == Self.Payment {
    func created(from payment: Payment) -> Future<CreatedResponse> {
        return self.container.future(payment)
    }
}

extension ExecutedPaymentResponse where ExecutedResponse == Self.Payment {
    func executed(from payment: Payment) -> Future<ExecutedResponse> {
        return self.container.future(payment)
    }
}


// MARK: - Enums
public enum RouteStructure {
    case mixed
    case separate
}
