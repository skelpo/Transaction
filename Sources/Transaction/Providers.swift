import Vapor

/// Registers `PaymentControllers` service controllers with the app's router.
public final class TransactionProvider: Provider {
    
    /// Creates a new instance of the provider.
    public init() {}
    
    /// See `Provider.register(_:)`.
    public func register(_ services: inout Services) throws {
        
    }
    
    /// See `Provider.willBoot(_:)`.
    public func willBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return container.future()
    }
    
    /// See `Provider.didBoot(_:)`.
    ///
    /// This is the method where we register the payment collections with the router.
    ///
    /// 1. Get the router from the container. If that fails, throw the error.
    /// 2. Get the registered `PaymentControllers` service. If that fails, throw the error.
    /// 3. Create a new router group with the root path for the controllers (if you added that).
    /// 4. Iterate over the controllers, registering each one with the new router group.
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        let router = try container.make(Router.self)
        let controllers = try container.make(PaymentControllers.self)
        
        let payments = (controllers.root == nil ? router : router.grouped(controllers.root!)).grouped(controllers.middleware)
        try controllers.controllers.forEach { controller in
            try payments.register(collection: controller)
        }
        
        return container.future()
    }
}
