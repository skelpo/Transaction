import Vapor

/// Indicates the immediate success or failure of a payment.
struct PaymentResponse<Purchase>: Content where Purchase: Buyable {
    
    /// Indicates whether the purchase succeeded or failed.
    var success: Bool = true
    
    ///
    var message: String = ""
    
    /// The URL the app should redirect to when the payment completes.
    var redirectUrl: String?
    
    ///
    var data: String?
    
    /// The ID of the payment data of the purchased item(s).
    var transactionID: Purchase.Payment.ID?
}
