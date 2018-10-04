import Core

/// A type that can be converted to a payment provider's payment model.
public protocol PaymentRepresentable {
    
    /// The `Payment` type that `PaymentRepresentable` can be converted to.
    associatedtype Payment
    
    /// Converts `PaymentRepresentable` to the `Payment` type.
    func payment() -> Future<Payment>
}
