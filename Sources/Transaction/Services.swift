import Vapor

/// The service that holds the `PyamentController` instances to register with the `TransactionProvider`.
public struct PaymentControllers: Service {
    
    /// The root path for the controllers. They will be registered at the top level of your app router if this is `nil`.
    internal let root: [PathComponentsRepresentable]?
    
    /// The controllers to register with the app router.
    internal var controllers: [RouteCollection] = []
    
    
    /// Creates a new `PaymentControllers` instance.
    ///
    /// - Parameter root: The root path for the controllers.
    public init(root: PathComponentsRepresentable...) {
        self.root = root
    }
    
    /// Creates a new `PaymentControllers` instance with `nil` as the `root` property value.
    public init() {
        self.root = nil
    }
    
    /// Adds a new controller to the service to be registered.
    public mutating func add<Payment>(_ controller: PaymentController<Payment>) {
        self.controllers.append(controller)
    }
}
