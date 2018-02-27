
import UIKit


public protocol TypeShowable {
    
    
    static var typeName: String { get }
    
    
    var typeName: String { get }
    
    
    
}


public extension TypeShowable {
    
    
    public static var typeName: String {
        return "\(Mirror(reflecting: self).subjectType)".components(separatedBy: ".")[0]
    }
    
    
    public var typeName: String {
        return "\(Mirror(reflecting: self).subjectType)"
    }
    
    
}


extension NSObject: TypeShowable {}
