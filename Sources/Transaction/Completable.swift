/// A type that can have a complete and not-complete state.
///
///     enum PaymentStatus: Int, Completable {
///        case paid
///        case enRoute
///
///        func isComplete() -> Bool {
///            switch self {
///            case .paid: return true
///            default: return false
///            }
///        }
///     }
public protocol Completable {
    
    /// Checks whether the current state is complete or not.
    func isComplete() -> Bool
}
