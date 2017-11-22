
import UIKit


public extension CGRect {
    
    
    public var x: CGFloat { return self.origin.x }
    public var y: CGFloat { return self.origin.y }
    
    
    public var center: CGPoint {
        return CGPoint(self.midX, self.midY)
    }
    
    
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init(x: x, y: y, width: width, height: height)
    }
}
