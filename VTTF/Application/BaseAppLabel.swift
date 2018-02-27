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
    func appLabel(caught label: BaseAppLabel, position: CGPoint)
}


 //ラベルの仕様
class BaseAppLabel: UILabel {
    static let labelSize = CGSize(width: 200, height: 200)
    var labelNumber: Int
    var id: String
    var delegate: BaseAppLabelDelegate?
    var startPoint: CGPoint?
    var labelPoint: CGPoint?
    var endPoint: CGPoint?
    var timer: Timer?
    var caught = true
    init(frame: CGRect, number: Int, id: String, flick: Flick) {
        labelNumber = number
        self.id = id
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize*4)
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.green
        self.minimumScaleFactor = 0.01
        self.text = "1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111"
        self.textColor = UIColor.black
        self.numberOfLines = 0
        self.textAlignment = NSTextAlignment.center
        if flick == .on {
            self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(BaseAppLabel.longTouch(_:))))
        }
//      self.addSubview(AppScrollView)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


//    override func draw(_ rect: CGRect) {
//    }

//
//    func moveLabelWithAnimation(start: CGPoint, end: CGPoint) {
//        UIView.animate(withDuration: TimeInterval(CGFloat(1.0)), animations: {() -> Void in
//            // 移動先の座標を指定する.
//            self.center = end
//
//        }, completion: {(Bool) -> Void in
//        })
//    }

    //フリック操作の詳細
    
    @objc func longTouch(_ sender:UILongPressGestureRecognizer?) {
        self.backgroundColor = UIColor.yellow
        let point = sender?.location(in: self.superview)
        if sender?.state == .began {
            print("began")
            startPoint = point
            labelPoint = self.center
        } else if sender?.state == .changed {
            print("changed")
        } else if sender?.state == .ended {
            print("ended")
            let dx = point!.x - startPoint!.x
            let dy = point!.y - startPoint!.y
            print("dx:\(dx),dy:\(dy)")

            let radian = Float(atan2(dx, dy))
            var endPoint2: CGPoint?
            
            //他端末の位置を見つけてラベルを飛ばす．
            
            for playerData in BaseApplicationManager.sharedInstance.players {
                let x2 = playerData.position.x
                let y2 = playerData.position.y
                let radian2 = Float(atan2(x2-startPoint!.x, y2-startPoint!.y))
                if radian2 >= radian - Float.pi/18 && radian2 <= radian + Float.pi/4.5 {
                    if let endPoint4 = endPoint2 {
                        let distance = (endPoint4.x - startPoint!.x)*(endPoint4.x - startPoint!.x) + (endPoint4.y - startPoint!.y)*(endPoint4.y - startPoint!.y)
                        let distance2 = (x2 - startPoint!.x)*(x2 - startPoint!.x) + (y2 - startPoint!.y)*(y2 - startPoint!.y)
                        if distance > distance2 {
                            endPoint2 = CGPoint(x: x2, y: y2)
                        }
                        
                    } else {
                        endPoint2 = CGPoint(x: x2, y: y2)
                    }
                }
            }
            if let endPoint3 = endPoint2 {
                endPoint = endPoint3
            } else {
                endPoint = CGPoint(x: self.labelPoint!.x + dx * 3, y: self.labelPoint!.y + dy * 3)
            }
            self.delegate?.appLabel(flickMoved: self, start: startPoint!, end: endPoint!)
            goAndReturn()
        }
    }
    
    func goAndReturn() {
        UIView.animate(withDuration: TimeInterval(CGFloat(1.0)), animations: {() -> Void in
            // 移動先の座標を指定する.
            self.center = self.endPoint!
            
        }, completion: {(Bool) -> Void in
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timeOut), userInfo: nil, repeats: false)
        })
        
        startPoint = self.center
        //   vc?.scrollView.scrollUnlock()
        
        caught = false
    }
    
    @objc func timeOut(tm: Timer) {
        print("timeOut")
        timer?.invalidate()
        if caught == false {
            UIView.animate(withDuration: TimeInterval(CGFloat(1.0)),
                           animations: {() -> Void in
                            // 移動先の座標を指定する.
                            self.center = CGPoint(x: self.labelPoint!.x, y: self.labelPoint!.y);
                            self.caught = true
            }, completion: {(Bool) -> Void in
                self.backgroundColor = UIColor.green
            })
        }
        
        
        // do something
    }
    // たかはし:タッチ操作が始まったタイミングでscrollViewのスクロール操作を停止する
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        if caught == true {
            self.backgroundColor = .red
            delegate?.appLabel(touchesBegan: self)
        } else {
            caught = true
            self.backgroundColor = .green
            delegate?.appLabel(caught: self, position: self.center)
        }
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
        backgroundColor = .green
        delegate?.appLabel(touchesEnded: self)
    }

    func makeBaseAppLabel(position: CGPoint) -> BaseAppLabelData {
        return BaseAppLabelData(id: id, number: labelNumber, position: position)
    }

    func makeEncodedBaseAppLabelData(position: CGPoint) -> Data? {
        let data = BaseAppLabelData(id: id, number: labelNumber, position: position)
        let encoder = JSONEncoder()
        do {
            let encoded: Data = try encoder.encode(data)
            return encoded
        } catch {
            return nil
        }
    }

    func makeEncodedBaseAppLabelFlickedData(end: CGPoint) -> Data? {
        if let start = startPoint {
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
    
    func makeEncodedBaseAppLabelCatchData(position: CGPoint) -> Data? {
        let d =  BaseAppLabelCatchData(id: id, position: position)
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
    let number: Int
    let position: CGPoint
}

struct BaseAppLabelFlickedData: Codable {
    let id: String
    let start: CGPoint
    let end: CGPoint
}

struct BaseAppLabelCatchData: Codable {
    let id: String
    let position: CGPoint
}

struct BaseAppLabelListData: Codable {
    let list: [BaseAppLabelData]
}



