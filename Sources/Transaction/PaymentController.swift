import Vapor


// MARK: - PaymentController

/// A controller that handles creating, executing, and refunding payments to a third-party payment provider.
public final class PaymentController<Provider>: RouteCollection where
    Provider: PaymentMethod & PaymentResponse, Provider.Purchase: Parameter, Provider.Purchase.ResolvedParameter == Future<Provider.Purchase>,
    Provider.Payment: Codable, Provider.ExecutionData: Content
{
    
    /// Whether the payment's creation and execution should be in two separate routes or be combined into a single route.
    public let structure: RouteStructure
    
    
    /// Creates a new `PaymentController` instance.
    ///
    /// - Parameter structure: Whether the payment's creation and execution should be in two separate routes or be combined into a single route.
    public init(structure: RouteStructure) {
        self.structure = structure
    }
    
    /// See `RouteCollection.boot(router:)`.
    public func boot(router: Router) throws {
        let payments = router.grouped(Provider.Purchase.parameter, "payment", Provider.slug)
        
        switch self.structure {
        case .mixed:
            payments.post(Provider.ExecutionData.self, use: run)
        case .separate:
            payments.post("create", use: create)
            payments.post(Provider.ExecutionData.self, at: "execute", use: execute)
        }
    }
    
    
    /// Creates a new payment for the controller's prokvider.
    public func create(_ request: Request)throws -> Future<Provider.CreatedResponse> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        let content = try request.content.decode(Provider.Purchase.PaymentContent.self)
        
        let payment = purchase.and(content).flatMap(provider.payment)
        return payment.flatMap(provider.created)
    }
    
    /// Executes a previously created payment for the controller's payment provider.
    public func execute(_ request: Request, body: Provider.ExecutionData)throws -> Future<Provider.ExecutedResponse> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        
        let payment = purchase.flatMap { $0.fetchPayment(on: request) }
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        return executed.flatMap(provider.executed)
    }
    
    /// Both creates and executed a payment in a single action. This should be used if the payment was created
    /// from the client instead of your server.
    public func run(_ request: Request, body: Provider.ExecutionData)throws -> Future<Provider.ExecutedResponse> {
        let provider = try request.make(Provider.self)
        let purchase = try request.parameters.next(Provider.Purchase.self)
        let content = try request.content.decode(Provider.Purchase.PaymentContent.self)
        
        let payment = purchase.and(content).flatMap(provider.payment)
        let executed = payment.and(result: body).flatMap(provider.execute)
        
        return executed.flatMap(provider.executed)
    }
}


// MARK: - Protocols

/// A combined protocol of `CreatedPaymentResponse` and `ExecutedPaymentResponse`.
public typealias PaymentResponse = CreatedPaymentResponse & ExecutedPaymentResponse

/// Allows a `PaymentController` instance to convert a purchase's payment instance
/// to be converted to a custom response for the `create` route handler.
public protocol CreatedPaymentResponse: PaymentMethod {
    
    /// The type returned from the `create` route handler. This defaults to `Payment`.
    associatedtype CreatedResponse: ResponseCodable = Self.Payment
    
    /// Converts the payment to a custom type. This defaults to returning the payment passed in.
    func created(from payment: Payment) -> Future<CreatedResponse>
}

/// Allows a `PaymentController` instance to convert a purchase's payment instance
/// to be converted to a custom response for the `execute` and `run` route handlers.
public protocol ExecutedPaymentResponse: PaymentMethod {
    
    /// The type returned from the `execute` and `run` route handlers. This defaults to `Payment`.
    associatedtype ExecutedResponse: ResponseCodable = Self.Payment
    
    /// Converts the payment to a custom type. This defaults to returning the payment passed in.
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

/// How a `PaymentController` instance's routes should be structured.
public enum RouteStructure {
    
    /// Register the `create` and `execute` operations for a payment in a single `run` route.
    case mixed
    
    /// Keep the `create` and `execute` payment operations in separate routes.
    case separate
}
