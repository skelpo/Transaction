import Vapor

public struct PaymentControllers: Service {
    internal let root: [PathComponentsRepresentable]
    internal var controllers: [RouteCollection] = []
    
    public init(root: PathComponentsRepresentable...) {
        self.root = root
    }
    
    public mutating func add<Payment>(_ controller: PaymentController<Payment>) {
        self.controllers.append(controller)
    }
}
