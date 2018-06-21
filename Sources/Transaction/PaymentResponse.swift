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
}
