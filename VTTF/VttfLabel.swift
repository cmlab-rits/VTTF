//
//  VttfLabel.swift
//  VTTF
//
//  Created by Yusuke Takahahsi on 2017/11/06.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.


import UIKit

class VttfLabel: UILabel {
    
    
    var vc: FirstScrollViewController?
    var n: Int = 0
    var startPoint: CGPoint?
    var labelPoint: CGPoint?
    var timer: Timer?
    var caught = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.green
        self.font = UIFont.systemFont(ofSize: 30)
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(VttfLabel.longTouch(_:))))
    }

    @objc func longTouch(_ sender:UILongPressGestureRecognizer?) {
        print("longtouch \(n)")
        n=n+1
        self.backgroundColor = UIColor.yellow
        var point = sender?.location(in: vc?.view)
        print(point)
        if sender?.state == .began {
            print("began")
            n = 0
            startPoint = point
            labelPoint = self.center
            
        } else if sender?.state == .changed {
            print("changed")
        } else if sender?.state == .ended {
            print("ended")
            let dx = point!.x - startPoint!.x
            let dy = point!.y - startPoint!.y
            print("dx:\(dx),dy:\(dy)")
            
            UIView.animate(withDuration: TimeInterval(CGFloat(1.0)),
                                       animations: {() -> Void in
                                        
            // 移動先の座標を指定する.
            self.center = CGPoint(x: self.labelPoint!.x + dx * 3, y: self.labelPoint!.y + dy * 3);
                                        
            }, completion: {(Bool) -> Void in
            })
            vc?.scrollView.scrollUnlock()
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timeOut), userInfo: nil, repeats: false)
            caught = false
        }
    }

    
    @objc func timeOut(tm: Timer) {
        print("timeOut")
        timer?.invalidate()
        if caught == false {
            UIView.animate(withDuration: TimeInterval(CGFloat(1.0)),
                           animations: {() -> Void in
                            
                            // 移動先の座標を指定する.
                            self.center = CGPoint(x: self.labelPoint!.x, y: self.labelPoint!.y);
                            
            }, completion: {(Bool) -> Void in
            })
        }
        
        // do something
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    // たかはし:タッチ操作が始まったタイミングでscrollViewのスクロール操作を停止する
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("began")
        self.superview?.bringSubview(toFront: self)
        self.backgroundColor = .red
        vc?.scrollView.scrollLock()
        caught = true
    }
    // たかはし: ドラッグ時の移動量から差分をviewの位置へ反映
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("moving")
        self.backgroundColor = .black
        guard let touch = touches.first else { return }
        
        let before = touch.previousLocation(in: superview)
        let after = touch.location(in: superview)
        
        var frame : CGRect = self.frame
        
        let dx = (after.x - before.x)
        let dy = (after.y - before.y)
        frame.origin.x += dx
        frame.origin.y += dy
        print("dx:\(dx),dy:\(dy)")
        self.frame = frame
    }
    // たかはし:操作が終わったらスクロール操作の停止を解除する
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("end")
        vc?.scrollView.scrollUnlock()
        backgroundColor = .blue
    }
    
}
