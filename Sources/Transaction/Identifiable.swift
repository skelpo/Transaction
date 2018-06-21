/// A type that can be identified through a unique identifier
public protocol Identifiable {
    
    /// A type that can represent a unique identifier.
    associatedtype ID: Codable, Equatable
    
    /// A unique ID for an instance of the type.
    var id: ID? { get }
}
