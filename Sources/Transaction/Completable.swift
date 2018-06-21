/// A type that can have a complete and not-complete state.
///
///     enum PaymentStatus: Int, Completable {
///        case paid
///        case enRoute
///
///        static func completed() -> PaymentStatus {
///            return .paid
///        }
///
///        func isComplete() -> Bool {
///            switch self {
///            case .paid: return true
///            default: return false
///            }
///        }
///     }
public protocol Completable {
    
    /// Gets an instance of `Self` in the completed state.
    static func completed() -> Self
    
    /// Checks whether the current state is complete or not.
    func isComplete() -> Bool
}
