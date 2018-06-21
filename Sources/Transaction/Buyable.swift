/// A type that can be purchased with a payment service
/// such as PayPal, Stripe, or CoinBase.
public protocol Buyable {
    
    /// A type that can represent a unique identifier.
    associatedtype ID
    
    /// A type that contains payment information related to the purchase,
    /// such as amount paid and the method of purchase.
    associatedtype Payment
    
    /// A type the represents the various statuses of a payment, such as
    /// not paid, processing, and paid.
    associatedtype PaymentStatus: Completable
    
    /// A unique ID for an instance of the type.
    var id: ID? { get }
}
