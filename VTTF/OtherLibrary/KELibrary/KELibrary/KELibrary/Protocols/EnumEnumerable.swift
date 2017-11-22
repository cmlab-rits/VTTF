
import UIKit


/** case一覧を得ることのできるプロトコル */
public protocol EnumEnumerable {
    
    
    associatedtype Case = Self


}


public extension EnumEnumerable where Case: Hashable {
    
    
    private static var iterator: AnyIterator<Case> {
        var n: Int = 0
        
        return AnyIterator {
            defer {
                n += 1
            }

            let next = withUnsafePointer(to: &n) {
                UnsafeRawPointer($0).assumingMemoryBound(to: Case.self).pointee
            }
            
            return next.hashValue == n ? next : nil
        }
    }
    
    public static func enumerated() -> EnumeratedSequence<AnySequence<Case>> {
        return AnySequence(self.iterator).enumerated()
    }
    
    public static var cases: [Case] {
        return Array(self.iterator)
    }
    

}
