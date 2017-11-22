
import UIKit


public class KERand {
    
    
    /**
     
     真偽値を乱数で得る
     
     */
    public class func randBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    
    /**
     
     n1 - n2 の範囲の間で乱数を得る
     
     */
    public class func minMaxRandInt(_ n1 : Int , _ n2 : Int) -> Int {
        
        let nn: [Int] = [n1, n2]

        let min: Int = nn.min()!
        let max: Int = nn.max()!

        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
}
