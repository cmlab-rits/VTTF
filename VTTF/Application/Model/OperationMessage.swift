//
//  OperationMessage.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/11/07.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation

enum Operation: String {
    case initalLabel = "initallabel"
    case moveLabel = "movelabel"
    case flickedLabel = "flickedLabel"
    case joinNewPlayer = "joinNewPlayer"
    case movePlayer = "movePlayer"
}

struct OperationMessage: Codable {
    let operation: String
    let data: Data

    func encode() -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            return nil
        }
    }
}

protocol DataMakeable {
    func makeOperationMessage() -> OperationMessage
}
