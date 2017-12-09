//
//  FlickGuideView.swift
//  VTTF
//
//  Created by Yuki Takeda on 2017/12/08.
//  Copyright © 2017年 cm.is.ritsumei.ac.jp. All rights reserved.
//

import UIKit

class FlickGuideView: UIView {

    // 20*2で40度の扇形ができる
    let angleSize = (CGFloat.pi * 2) * 20 / 360
    private var panStartPoint: CGPoint?
    private var panEndPoint: CGPoint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func draw(_ rect: CGRect) {
        isOpaque = false
        let context = UIGraphicsGetCurrentContext()!
        let radius = min(frame.size.width, frame.size.height)/2
        let viewCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)

        context.setFillColor(UIColor(hue: 0.7, saturation: 0.5, brightness: 0.5, alpha: 0.5).cgColor)
        context.fillEllipse(in: rect)

        let testAngle = angle(a: CGPoint(50, 50), b: CGPoint(50,0)) * 2 * CGFloat.pi
        let startAngle = testAngle - angleSize
        let endAngle = testAngle + angleSize

        context.setFillColor(UIColor.red.cgColor)
        context.move(to: viewCenter)
        context.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.closePath()
        context.fillPath()

        self.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
    }

    func reload() {
        setNeedsDisplay()
    }

    // return: 0-1
    func angle(a: CGPoint, b: CGPoint) -> CGFloat {
        var r = atan2(b.doubleY - a.doubleY, b.doubleX - a.doubleX)
        if r < 0 {
            r = r + 2 * Double.pi
        }
        let val = r / (2 * Double.pi)
        return CGFloat(val)
    }

    @objc func panGesture(sender:UIPanGestureRecognizer) {
        switch (sender.state) {
        case .began:
            panStartPoint = sender.translation(in: sender.view)
            print("pan start")
            break
        case .ended:
            print("pan end")
            panEndPoint = sender.translation(in: sender.view)
            print(angle(a: panStartPoint!, b: panEndPoint!))
            break
        default:
            break
        }
    }
}
extension CGPoint {
    var doubleX: Double {
        return Double(self.x)
    }
    var doubleY: Double {
        return Double(self.y)
    }
}
