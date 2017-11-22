//
//  BaseApplicationViewController.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit

class BaseApplicationViewController: UIViewController {

    private let appManager = BaseApplicationManager.sharedInstance
    private let ccManager = ColorCoordinateManager.sharedInstance

    private var scrollView = AppScrollView()
    private var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        ccManager.addDelegate(target: self)
        appManager.delegate = self

        // たかはし: ここではUIScrollViewではなく独自実装のscrollViewを宣言
        scrollView = AppScrollView(frame: self.view.frame)
        scrollView.contentSize = appManager.workspaceSize
        scrollView.backgroundColor = UIColor.clouds
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.minimumZoomScale = self.view.frame.width / appManager.basisWorkspaceSize.width
        scrollView.maximumZoomScale = 1.0


        contentView = UIView(frame: CGRect(origin: CGPoint(0,0), size: appManager.workspaceSize))
        scrollView.addSubview(contentView)
        // MEMO: 間違ってるけどカラーセンサでは絶対位置を取ってくるからどうでもいい
        scrollView.contentOffset = calcStartPoint()
        addLabel()
        scrollView.delegate = self
        scrollView.pinchGestureRecognizer?.addTarget(self, action: #selector(pinchAction(sender:)))

        let actionButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "Setting"), style: .plain, target: self, action: #selector(MonitoringViewController.didPushSettingButton))
        self.navigationItem.rightBarButtonItem = actionButton
    }

    @objc func didPushSettingButton() {
        self.present(SettingNavigationViewController(), animated: true, completion: nil)
    }

    @objc func pinchAction(sender: UIPinchGestureRecognizer) {
        if sender.velocity <= -0.3{
            zoomOutScrollView()
        } else if sender.velocity >= 0.3{
            zoomInScrollView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func calcStartPoint() -> CGPoint {
        let x = appManager.workspaceSize.width / 2
        let y = appManager.workspaceSize.height - ( view.frame.height / 2 )
        return CGPoint(x: x, y: y)
    }

    // たかはし:それぞれのラベルにscrollViewへの参照を持たせておく
    func addLabel() {
        for label in appManager.fieldLabels {
            self.contentView.addSubview(label)
        }
    }

    public func scrollLock() {
        scrollView.scrollLock()
    }

    public func scrollUnlock() {
        scrollView.scrollUnlock()
    }

    func zoomOutScrollView() {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }

    func zoomInScrollView() {
        scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
    }

}

extension BaseApplicationViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}

extension BaseApplicationViewController: BaseAppManagerDelegate {
}


extension BaseApplicationViewController: ColorCoordinateManagerDelegate {
    func updatePosition(manager: ColorCoordinateManager, position: PositionModel) {
        let newX = (scrollView.contentSize.width * position.x) - (view.frame.width / 2 )
        let newY = scrollView.contentSize.height * position.y - (view.frame.height / 2 )

        appManager.updateOwnPlayerPosition(point: CGPoint(x: newX, y: newY))

        UIView.animate(withDuration: 0.1, animations: {
            self.scrollView.contentOffset.x = newX
            self.scrollView.contentOffset.y = newY

        })


    }

    func updateCaribration(manager: ColorCoordinateManager, progress: Float){}
    func completeCaribration(manager: ColorCoordinateManager, color: ColorModel){}
    func ccManager(manager: ColorCoordinateManager, updateNewModelToSaturationScaleCaribration color: ColorModel, count: Int){}
    func ccManager(manager: ColorCoordinateManager, updateColorPattern type: ColorPatternType){}
}

class AppScrollView: UIScrollView {
    public func scrollLock() {
        self.isScrollEnabled = false
    }

    public func scrollUnlock() {
        self.isScrollEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesMoved(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesEnded(touches, with: event)
    }
}

