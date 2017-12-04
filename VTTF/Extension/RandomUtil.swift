//
//  RandomUtil.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/11/11.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation

class RandomUtil {
    class func generate(length: Int) -> String {
        let base = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z","1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += base[Int(randomValue)]
        }
        return randomString
    }

    class func generate16length() -> String {
        return generate(length: 16)
    }
}

