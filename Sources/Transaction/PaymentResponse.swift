import Vapor

/// Indicates the immediate success or failure of a payment.
public struct PaymentResponse<Purchase>: Content where Purchase: Buyable {
    
    /// Indicates whether the purchase succeeded or failed.
    public var success: Bool = true
    
    ///
    public var message: String = ""
    
    /// The URL the app should redirect to when the payment completes.
    public var redirectUrl: String?
    
    ///
    public var data: String?
    
    /// The ID of the payment data of the purchased item(s).
    public var transactionID: Purchase.Payment.ID?
    
    /// Initialize a new `PaymentResponse` instance.
    public init(success: Bool = true, message: String = "", redirectUrl: String? = nil, data: String? = nil, transactionID: Purchase.Payment.ID? = nil) {
        self.success = success
        self.message = message
        self.redirectUrl = redirectUrl
        self.data = data
        self.transactionID = transactionID
    }
}
