//
//  Player.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import Foundation
import UIKit


class Player {
    let id: String
    var name: String
    var position: CGPoint
    let type: PlayerType

    init(id: String, name: String, position: CGPoint, type: PlayerType) {
        self.id = id
        self.name = name
        self.position = position
        self.type = type
    }

    func makeEncodedPlayerData() -> Data? {
        let data = PlayerData(id: id, name: name, position: position)
        let encoder = JSONEncoder()
        do {
            let encoded: Data = try encoder.encode(data)
            return encoded
        } catch {
            return nil
        }
    }

    func makeBaseAppLabel() -> PlayerData {
        return PlayerData(id: id, name: name, position: position)
    }
}

struct PlayerData: Codable {
    var id: String
    var name: String
    var position: CGPoint
}
