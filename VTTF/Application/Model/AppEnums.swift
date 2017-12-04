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


enum RoleInApp: String{
    case leader = "leader"
    case member = "member"
}

extension RoleInApp: EnumEnumerable {}


enum Direction: String {
    case front = "正面"
    case back = "反対"
    case left = "左"
    case right = "右"
//    case manual(CGFloat)
}
extension Direction: EnumEnumerable {}

