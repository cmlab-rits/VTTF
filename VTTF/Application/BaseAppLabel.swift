//
//  BaseAppLabel.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/29.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit

protocol BaseAppLabelDelegate {
    func appLabel(touchesBegan label: BaseAppLabel)
    func appLabel(touchesMoved label: BaseAppLabel)
    func appLabel(touchesEnded label: BaseAppLabel)
    func appLabel(flickMoved label: BaseAppLabel, start: CGPoint, end: CGPoint)
    func appLabel(longPressed label: BaseAppLabel)
}


class BaseAppLabel: UILabel {
    var appManager = BaseApplicationManager.sharedInstance
    var labelNumber: Int
    var id: String
    var delegate: BaseAppLabelDelegate?

    var startPoint: CGPoint?
    var labelPoint: CGPoint?
    var endPoint: CGPoint?
    var caught = false


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
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(BaseAppLabel.longTouch(_:))))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
    }

    func moveLabelWithAnimation(start: CGPoint, end: CGPoint) {
        UIView.animate(withDuration: TimeInterval(CGFloat(1.0)), animations: {() -> Void in
            // 移動先の座標を指定する.
            self.center = end

        }, completion: {(Bool) -> Void in
        })
    }

    @objc func longTouch(_ sender:UILongPressGestureRecognizer?) {
        self.backgroundColor = UIColor.yellow
//        let point = sender?.location(in: self.superview)
        if sender?.state == .began {
            self.delegate?.appLabel(longPressed: self)
        } else if sender?.state == .changed {
            print("changed")
        } else if sender?.state == .ended {

        }
    }


//    @objc func timeOut(tm: Timer) {
//        print("timeOut")
//        timer?.invalidate()
//        if caught == false {
//            UIView.animate(withDuration: TimeInterval(CGFloat(1.0)),
//                           animations: {() -> Void in
//
//                            // 移動先の座標を指定する.
//                            self.center = CGPoint(x: self.labelPoint!.x, y: self.labelPoint!.y);
//
//            }, completion: {(Bool) -> Void in
//            })
//        }
//
//        // do something
//    }

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

    func makeBaseAppLabel() -> BaseAppLabelData {
        return BaseAppLabelData(id: id, position: appManager.convertToBasisPoint(point: self.midPoint))
    }

    func makeEncodedBaseAppLabelData() -> Data? {
        let data = BaseAppLabelData(id: id, position: appManager.convertToBasisPoint(point: self.midPoint))
        let encoder = JSONEncoder()
        do {
            let encoded: Data = try encoder.encode(data)
            return encoded
        } catch {
            return nil
        }
    }

    func makeEncodedBaseAppLabelFlickedData() -> Data? {
        if let start = startPoint, let end = endPoint {
            let d =  BaseAppLabelFlickedData(id: id, start: start, end: end)
            let encoder = JSONEncoder()
            do {
                let encoded: Data = try encoder.encode(d)
                return encoded
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

    func makeEncodedBaseAppLabelUserFlickedData(from: Player, to: Player) -> Data? {
        let start = appManager.convertToBasisPoint(point: self.midPoint)
        let end = appManager.convertToBasisPoint(point: to.position)
        let d = BaseAppLabelUserFlickedData(id: id, start: start, end: end, fromPlayerID: from.id, toPlayerID: to.id)
        let encoder = JSONEncoder()
        do {
            let encoded: Data = try encoder.encode(d)
            return encoded
        } catch {
            return nil
        }
    }

}

//extension BaseAppLabel: 

struct BaseAppLabelData: Codable {
    let id: String
    let position: CGPoint
}

struct BaseAppLabelFlickedData: Codable {
    let id: String
    let start: CGPoint
    let end: CGPoint
}

struct BaseAppLabelUserFlickedData: Codable{
    let id: String
    let start: CGPoint
    let end: CGPoint
    let fromPlayerID: String
    let toPlayerID: String
}

struct BaseAppLabelListData: Codable {
    let list: [BaseAppLabelData]
}



