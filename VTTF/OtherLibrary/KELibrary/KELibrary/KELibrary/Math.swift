
import UIKit


/* CGRect */
public func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
    return CGRect(x, y, w, h)
}
public var CGRectZero: CGRect {
    return CGRect(0, 0, 0, 0)
}


/* CGPoint */
public func CGPointMake(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
    return CGPoint(x, y)
}
public var CGPointZero: CGPoint {
    return CGPoint(0, 0)
}
/** CGPoint間の距離を求める */
public func CGPointDistance(_ p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    let dx: CGFloat = p1.x - p2.x
    let dy: CGFloat = p1.y - p2.y
    return sqrt(dx*dx + dy*dy)
}
/** CGRect の対角の座標を求める */
public func CGPointDiagonal(_ rect: CGRect) -> CGPoint {
    return CGPoint(rect.x + rect.width, rect.y + rect.height)
}
/** UIView の対角の座標を求める */
public func CGPointDiagonal(_ view: UIView) -> CGPoint {
    return CGPoint(view.x + view.width, view.y + view.height)
}
/* CGPoint の加算 */
public func +(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(l.x + r.x, l.y + r.y)
}
public func +=(l: inout CGPoint, r: CGPoint) {
    l = l + r
}
/* CGPoint の減算 */
public func -(l: CGPoint, r: CGPoint) -> CGPoint {
    return CGPoint(l.x - r.x, l.y - r.y)
}
public func -=(l: inout CGPoint, r: CGPoint) {
    l = l - r
}
public prefix func -(p: CGPoint) -> CGPoint {
    return CGPoint(-p.x, -p.y)
}


/* CGSize */
public func CGSizeMake(_ width: CGFloat, _ height: CGFloat) -> CGSize {
    return CGSize(width, height)
}
public var CGSizeZero: CGSize {
    return CGSize(0, 0)
}

