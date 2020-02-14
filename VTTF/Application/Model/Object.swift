//
//  Object.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit

protocol Object {
    var id: String { get set }
    var position: CGFloat { get set }
}
