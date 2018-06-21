/// A type that can be purchased with a payment service
/// such as PayPal, Stripe, or CoinBase.
public protocol Buyable: Codable, Identifiable {
    
    /// A type that contains payment information related to the purchase,
    /// such as amount paid and the method of purchase.
    associatedtype Payment: Codable, Identifiable
    
    /// A type the represents the various statuses of a payment, such as
    /// not paid, processing, and paid.
    associatedtype PaymentStatus: Codable, Completable
}
