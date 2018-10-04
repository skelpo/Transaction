import Service

// P = Third-party API
//
// - Create P.Payment object
//
// PayPal:
//   - Register payment with PayPal
//   - Get payment authorization redirect
//   - Execute payment
//
// Stripe:
//   - Charge the card the user registered from the browser


/// A generic representation of a payment service, such as
/// PayPal, Stripe, or CoinBase.
public protocol PaymentMethod: ServiceType {
    
    /// The type used by the back-end app to represent an e-commerce purchase.
    associatedtype Purchase
    
    /// The type used by the third-party payment provider to represent a payment.
    associatedtype Payment
    
    /// Additional data that gets sent to the payment provider so the payment can succsefully execute.
    ///
    /// If you don't need this type, you can set it to something arbitrary like `String` or `Any`.
    associatedtype ExecutionData
    
    
    /// The proper name of the payment provider that is connected to, such as `PayPal` or `Stripe`.
    var name: String { get }
    
    /// The case insensetive ID for the payment provider.
    var slug: String { get }
    
    /// The worker that the transaction runner is connected to.
    var container: Container { get }
    
    
    /// Creates a new instance of the type that implements the protocol.
    ///
    /// - Note: Instead of calling this initializer, you should register the type with your app's services:
    ///
    ///       services.register(Payment.self)
    init(container: Container)
    
    /// Converts the `Purchase` type used by your app to the provider's `Payment` type.
    /// In some cases, this method should send the payment to the provider to be created (PayPal),
    /// while in others that has already been done on the client side (Stripe)
    ///
    /// You can use this method to save the payment to a database if you want to.
    ///
    /// - Parameter purchase: The purchase type object to convert to a provider's payment.
    ///
    /// - Returns: The payment object that gets sent to the payment provider.
    func payment(for purchase: Purchase) -> Future<Payment>
    
    /// Activates whatever logic is required to cause the payment to execute that has been created with the payment provider.
    ///
    /// - Parameters:
    ///   - payment: The payment object for the provider to execute, so a merchant gets paid.
    ///   - data: Additional data that is sent along with the payment to the provider so the payment can execute.
    ///
    /// - Returns: A void future that indicates when the operation is complete.
    func execute(payment: Payment, with data: ExecutionData) -> Future<Void>
}

extension PaymentMethod {

    /// Creates a new instance of the service for the supplied `Container`.
    ///
    /// See `ServiceFactory` for more information.
    public static func makeService(for worker: Container) throws -> Self {
        return Self.init(container: worker)
    }
}
