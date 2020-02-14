//
//  AppEnums.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit

enum PlayerType {
    case own
    case other
}

enum ItemType {
    case player
    case object
}


enum RoleInApp: CaseIterable {
    case leader
    case member
    var rawValue: String {
        switch self {
        case .leader:   return "leader"
        case .member:   return "members"
        }
    }
}

//extension RoleInApp: EnumEnumerable {}


enum Direction: CaseIterable {
    case front
    case back
    case left
    case right
    var rawValue: String {
        switch self {
        case .front:    return "正面"
        case .back:     return "反対"
        case .left:     return "左"
        case .right:    return "右"
        }
    }
}

