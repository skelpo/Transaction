import Vapor

public final class TransactionProvider: Provider {
    public init() {}
    
    public func register(_ services: inout Services) throws {
        
    }
    
    public func willBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return container.future()
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        let router = try container.make(Router.self)
        let controllers = try container.make(PaymentControllers.self)
        
        let payments = controllers.root == nil ? router : router.grouped(controllers.root!)
        try controllers.controllers.forEach { controller in
            try payments.register(collection: controller)
        }
        
        return container.future()
    }
}
