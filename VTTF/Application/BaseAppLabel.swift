//
//  BaseAppLabel.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/29.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit
import KELibrary

protocol BaseAppLabelDelegate {
    func appLabel(touchesBegan label: BaseAppLabel)
    func appLabel(touchesMoved label: BaseAppLabel)
    func appLabel(touchesEnded label: BaseAppLabel)
}


class BaseAppLabel: UILabel {
    var labelNumber: Int
    var id: String
    var delegate: BaseAppLabelDelegate?

    init(frame: CGRect, number: Int, id: String) {
        labelNumber = number
        self.id = id
        super.init(frame: frame)
        self.isUserInteractionEnabled = true

        self.backgroundColor = UIColor.green
        self.text = "testtesttesttet"
        self.textColor = .black
        self.numberOfLines = 0
        self.textAlignment = .left
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
    }

    // たかはし:タッチ操作が始まったタイミングでscrollViewのスクロール操作を停止する
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        self.backgroundColor = .red
        delegate?.appLabel(touchesBegan: self)
    }
    // たかはし: ドラッグ時の移動量から差分をviewの位置へ反映
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundColor = .black
        guard let touch = touches.first else { return }

        let before = touch.previousLocation(in: superview)
        let after = touch.location(in: superview)

        var frame : CGRect = self.frame

        let dx = (after.x - before.x)
        let dy = (after.y - before.y)
        frame.origin.x += dx
        frame.origin.y += dy
        self.frame = frame
        delegate?.appLabel(touchesMoved: self)
    }
    // たかはし:操作が終わったらスクロール操作の停止を解除する
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .blue
        delegate?.appLabel(touchesEnded: self)
    }

    func makeEncodedBaseAppLabelData() -> Data? {
        let data = BaseAppLabelData(id: id, position: self.frame.center)
        let encoder = JSONEncoder()
        do {
            let encoded: Data = try encoder.encode(data)
            return encoded
        } catch {
            return nil
        }
    }

    func makeBaseAppLabel() -> BaseAppLabelData {
        return BaseAppLabelData(id: id, position: self.midPoint)
    }

}

//extension BaseAppLabel: 

struct BaseAppLabelData: Codable {
    let id: String
    let position: CGPoint
}

struct BaseAppLabelListData: Codable {
    let list: [BaseAppLabelData]
}



