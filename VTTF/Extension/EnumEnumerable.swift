//
//  EnumEnumerable.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/09/06.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation

public protocol EnumEnumerable {
    associatedtype Case = Self
}

public extension EnumEnumerable where Case: Hashable {
    private static var iterator: AnyIterator<Case> {
        var n = 0
        return AnyIterator {
            defer { n += 1 }

            let next = withUnsafePointer(to: &n) {
                UnsafeRawPointer($0).assumingMemoryBound(to: Case.self).pointee
            }
            return next.hashValue == n ? next : nil
        }
    }

    public static func enumerate() -> EnumeratedSequence<AnySequence<Case>> {
        return AnySequence(self.iterator).enumerated()
    }

    public static var cases: [Case] {
        return Array(self.iterator)
    }

    public static var count: Int {
        return self.cases.count
    }
}
