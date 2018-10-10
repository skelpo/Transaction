import Core
import Service

/// A type that can be converted to a payment provider's payment model.
public protocol PaymentRepresentable {
    
    /// The `Payment` type that `PaymentRepresentable` can be converted to.
    associatedtype Payment
    
    /// Converts `PaymentRepresentable` to the `Payment` type.
    func payment<Method, ID>(
        on container: Container,
        with method: Method,
        externalID: ID
    ) -> Future<Payment> where Method: PaymentMethod, ID: Identifiable
    
    /// Gets an already created `Payment` instance.
    func fetchPayment(on container: Container) -> Future<Payment>
}

public protocol Identifiable: Codable {
    associatedtype ID: Codable
    
    var id: ID { get }
}
