import Service

/// A generic representation of a payment service, such as
/// PayPal, Stripe, or CoinBase.
public protocol PaymentMethod: ServiceType {
    
    /// The type of object that the payment service will be used to purchase.
    associatedtype Purchase: Buyable
    
    /// Can this payment method take time, like a few minutes or hours until it is finished?
    static var pendingPossible: Bool { get }
    
    /// Is pre-authentification needed? Like when charging a credit card?
    /// Note: This may be "chosen" and not obgligated. The final charge may be wanted a little later.
    static var preauthNeeded: Bool { get }
    
    /// The name of this payment method.
    static var name: String { get }
    
    ///
    static var slug: String { get }
    
    /// Initializes the payment method with credentials.
    init(container: Container)
    
    /// Is called periodically to update pending transactions.
    func workThroughPendingTransactions()
    
    /// Creates a new transaction. This function is used internally.
    func createTransaction(
        from purchase: Purchase,
        userId: Int,
        amount: Int?,
        status: Purchase.PaymentStatus?,
        paymentInit: @escaping (Purchase.ID, String, Int, Int) -> (Purchase.Payment)
    ) -> Future<Purchase.Payment>
    
    /// Pays for a `Purchase` instance.
    func pay(
        for order: Purchase,
        userId: Int,
        amount: Int,
        params: Codable?,
        paymentInit: @escaping (Purchase.ID, String, Int, Int) -> (Purchase.Payment)
    ) throws -> Future<PaymentResponse<Purchase>>
    
    ///
    func refund(payment: Purchase.Payment, amount: Int?) -> Future<Purchase.Payment>
}

extension PaymentMethod {

    /// Creates a new instance of the service for the supplied `Container`.
    ///
    /// See `ServiceFactory` for more information.
    public static func makeService(for worker: Container) throws -> Self {
        return Self.init(container: worker)
    }
}
