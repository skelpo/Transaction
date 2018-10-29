import Vapor

/// The service that holds the `PyamentController` instances to register with the `TransactionProvider`.
public struct PaymentControllers: Service {
    
    /// The root path for the controllers. They will be registered at the top level of your app router if this is `nil`.
    internal let root: [PathComponentsRepresentable]?
    
    /// The middleware registered with the routes in the `controllers` route collections.
    internal var middleware: [Middleware]
    
    /// The controllers to register with the app router.
    internal var controllers: [RouteCollection] = []
    
    
    /// Creates a new `PaymentControllers` instance.
    ///
    /// - Parameters:
    ///   - root: The root path for the controllers.
    ///   - middleware:
    public init(root: PathComponentsRepresentable..., middleware: [Middleware] = []) {
        self.root = root
        self.middleware = []
    }
    
    /// Creates a new `PaymentControllers` instance with `nil` as the `root` property value.
    public init(middleware: [Middleware] = []) {
        self.root = nil
        self.middleware = middleware
    }
    
    /// Adds a new controller to the service to be registered.
    public mutating func add<Payment>(_ controller: PaymentController<Payment>) {
        self.controllers.append(controller)
    }
    
    /// Adds a new middleware that the service's controllers will be registered with.
    public mutating func middleware(_ middleware: Middleware) {
        self.middleware.append(middleware)
    }
}
