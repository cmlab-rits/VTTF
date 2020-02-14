
import UIKit


public extension Array {
    
    
    /**
     
     配列をシャッフルする
     
     */
    mutating func shuffle() {
        let n: Int = self.count
        for _ in 0..<n {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
    
    
    /**
     
     配列から要素を取り除く
     
     - parameter obj: 取り除く要素
     
     */
    mutating func remove<T: Equatable>(_ obj: T) {
        self = self.filter { $0 as? T != obj }
    }
    
    
    /**
     
     配列の積を求める
     
     - returns: 重複した要素の配列
     
     */
    func intersect<T: Equatable>(_ obj: [T]) -> [T]
    {
        var ret = [T]()

        for x in self {
            if let y: T = x as? T {
                if obj.contains(y) {
                    ret.append(y)
                }
            }
        }

        return ret
    }
    
    
    /**
     
     配列をファイルに保存する
     
     */
    @discardableResult public func writeTo(_ file: String, atomically: Bool) -> Bool {
        return (self as NSArray).write(toFile: file, atomically: atomically)
    }
}
