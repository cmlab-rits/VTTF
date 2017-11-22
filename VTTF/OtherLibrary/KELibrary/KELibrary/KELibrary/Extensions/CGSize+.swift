
import UIKit


public extension CGSize {
    
    
    public var halfWidth : CGFloat { return self.width  / 2.0 }
    public var halfHeight: CGFloat { return self.height / 2.0 }
    
    
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init(width: width, height: height)
    }
}
