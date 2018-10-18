import Core
import Service

/// A type that can be converted to a payment provider's payment model.
public protocol PaymentRepresentable {
    
    /// The `Payment` type that `PaymentRepresentable` can be converted to.
    associatedtype Payment
    
    /// Additional data required by the `Payment` type to be initialized.
    ///
    /// This type can be set to `VoidCodable` if you don't need it.
    associatedtype PaymentContent: Codable
    
    /// Converts `PaymentRepresentable` to the `Payment` type.
    func payment<Method, ID>(
        on container: Container,
        with method: Method,
        content: PaymentContent,
        externalID: ID?
    ) -> Future<Payment> where Method: PaymentMethod
    
    /// Gets an already created `Payment` instance.
    func fetchPayment(on container: Container) -> Future<Payment>
}


/// An empty type that conform to `Codable`
public struct VoidCodable: Codable {
    
    /// Creates a new `VoidCodable` instance.
    public init() {}
}
