import Vapor

public struct PaymentControllers: Service {
    internal let root: [PathComponentsRepresentable]?
    internal var controllers: [RouteCollection] = []
    
    public init(root: PathComponentsRepresentable...) {
        self.root = root
    }
    
    public init() {
        self.root = nil
    }
    
    public mutating func add<Payment>(_ controller: PaymentController<Payment>) {
        self.controllers.append(controller)
    }
}
