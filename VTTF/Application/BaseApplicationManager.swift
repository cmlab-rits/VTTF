//
//  BaseApplicationManager.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/28.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol BaseAppManagerDelegate {
    func appManager(manager: BaseApplicationManager, scroll move: (Int, Int))
}

class BaseApplicationManager: NSObject {
    static let sharedInstance = BaseApplicationManager()

    private let mcManager = MCManager.sharedInstance

    private let socketManager = SocketManager.sharedInstance

    private var viewController: BaseApplicationViewController?

    private var ownPlayer: Player?

    var players: [Player] = []

    private var direction: Direction?
    
    var role: RoleInApp?
    
    var flick: Flick?
    
    var startPotiton: StartPosition?

    private var taskLabelCount: Int = 4
    
    var delegate: BaseAppManagerDelegate?
    
    var fieldLabels: [BaseAppLabel] = []

    var basisWorkspaceSize: CGSize = CGSize(width: 6144, height: 4096)

    var timer: Timer?
    
    var currentSelectedLabel: BaseAppLabel?
    
    var workspaceSize: CGSize {
        guard let direction = direction else { return basisWorkspaceSize }

        switch direction {
        case .front, .back:
            return basisWorkspaceSize
        case .left, .right:
            return CGSize(width: basisWorkspaceSize.height, height: basisWorkspaceSize.width)
        }
    }
    
    override init() {
        super.init()
        mcManager.delegate = self
        socketManager.delegate = self
    }

    func startApplication() {
        guard let role = role, let direction = direction else { return }
        mcManager.startManager()
        ownPlayer = Player(id: RandomUtil.generate16length(), name: UIDevice.current.name, position: CGPointZero, type: .own)
    
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timeOut), userInfo: nil, repeats: true)
    }
    
    @objc func timeOut(tm: Timer) {
        if let offset = viewController?.scrollView.contentOffset, let dir = direction {
            let offset2 = CGPoint(offset.x + (viewController?.view.frame.width)!/2, offset.y + (viewController?.view.frame.height)!/2)
            let offset3 = convertFromDirectionPointToBasisPoint(dir: dir, point: offset2)
            if ownPlayer?.position != offset3 {
                updateOwnPlayerPosition(point: offset2)
                shareMovePlayer()
            }
        }
    }
    
    
    
    func setupInitialSetting(role: RoleInApp, dir: Direction,flick: Flick, startPotiton: StartPosition,vc: BaseApplicationViewController) {
        self.role = role
        self.direction = dir
        self.flick = flick
        self.viewController = vc
        self.startPotiton = startPotiton
        startApplication()
    }

    func updateOwnPlayerPosition(point: CGPoint) {
        let basePoint = convertFromDirectionPointToBasisPoint(dir: direction!, point: point)
        ownPlayer?.position = basePoint
    }


    /// 作業空間に配置するラベルをつくる
    func setupFieldObjects() {
        print("setupFieldObjects")
        fieldLabels.removeAll()
        for i in 0..<taskLabelCount {
            let rect = CGRect(origin: genarateRandomPointInWorkspaceCircle(), size: BaseAppLabel.labelSize)
            let imgName = "img0\(i+1)"
            let id = "baseapplabel:\(i)"
            let label = BaseAppLabel(frame: rect, imageName: imgName, id: id, flick: flick!)
            label.delegate = self

            //仮
            label.tag = i
            fieldLabels.append(label)
        }
    }

    /// 作業空間の円の中でランダムな点を得る
    private func genarateRandomPointInWorkspaceCircle() -> CGPoint {
        var point = CGPoint(x: 0,y: 0)

//        repeat {
            point.x = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.width-BaseAppLabel.labelSize.width)))
            point.y = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.height-BaseAppLabel.labelSize.height)))
//        } while !checkCoodinateInCircle(point: point)

        return point
    }

    /**
     作業空間が正方形のとき、ある点がカラーパターンでカバーできる円の内部に存在するかをチェックする
     */
    private func checkCoodinateInCircle(point: CGPoint) -> Bool {
        let halfR = pow(workspaceSize.halfWidth, 2)
        let wid = pow(workspaceSize.width - point.x, 2)
        let hei = pow(workspaceSize.height - point.y, 2)

        if (wid + hei) <= halfR {
            return true
        } else {
            return false
        }
    }


    /// 基の座標から方向に応じて座標を変換する
    ///
    /// - Parameters:
    ///   - dir: 方向
    ///   - point: 基の座標
    /// - Returns: 方向に応じた座標
    func convertFromBasisPointToDirectionPoint(dir: Direction, from point: CGPoint) -> CGPoint {
        var p: CGPoint = point
        switch dir {
        case .front:
            break
        case .back:
            p.x = basisWorkspaceSize.width - point.x
            p.y = basisWorkspaceSize.height - point.y
        case .left:
            p.x = point.y
            p.y = basisWorkspaceSize.width - point.x
        case .right:
            p.x = basisWorkspaceSize.height - point.y
            p.y = point.x
        }
        return p
    }


    /// 方向に応じた座標から基の座標に変換する
    ///
    /// - Parameters:
    ///   - dir: 方向
    ///   - point: 方向に応じた座標
    /// - Returns: 基の座標
    func convertFromDirectionPointToBasisPoint(dir: Direction, point: CGPoint) -> CGPoint{
        var p: CGPoint = point
        switch dir {
        case .front:
            break
        case .back:
            p.x = basisWorkspaceSize.width - point.x
            p.y = basisWorkspaceSize.height - point.y
        case .left:
            p.x = basisWorkspaceSize.width - point.y
            p.y = point.x
        case .right:
            p.x = point.y
            p.y = basisWorkspaceSize.height - point.x
        }
        return p
    }

    /*
     ラベルの共有系の処理
    */

    /// ラベルの初期化
    
    func initalizeShareAllLabel(){
        print("initalizeShareAllLabel")
//        let labelDataArray = fieldLabels.flatMap{ $0.makeBaseAppLabel(position: convertFromDirectionPointToBasisPoint(dir: direction!, point: $0.bounds.origin)) }
        let labelDataArray = fieldLabels.flatMap{ $0.makeBaseAppLabel(position: $0.center) }
        let encoder = JSONEncoder()
        do {
            let encoded = try encoder.encode(labelDataArray)
            print(encoded)
            let message = OperationMessage(operation: Operation.initalLabel.rawValue, data: encoded)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        } catch {
            fatalError()
        }
    }
    
    /// ラベルの移動
    func shareMoveLabel(label: BaseAppLabel) {
        print("sharelabel")
        
        let position2 = convertFromDirectionPointToBasisPoint(dir: direction!, point: label.center)
        if let labelData = label.makeEncodedBaseAppLabelData(position: position2) {
            let message = OperationMessage(operation: Operation.moveLabel.rawValue, data: labelData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// フリックによるラベルの移動
    func shareFlickedLabel(label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        let end2 = convertFromDirectionPointToBasisPoint(dir: direction!, point: end)
        if let flickedData = label.makeEncodedBaseAppLabelFlickedData(end: end2) {
            let message = OperationMessage(operation: Operation.flickedLabel.rawValue, data: flickedData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    func shareCatchLabel(label: BaseAppLabel, position: CGPoint) {
        let position2 = convertFromDirectionPointToBasisPoint(dir: direction!, point: position)
        if let catchData = label.makeEncodedBaseAppLabelCatchData(position: position2) {
            let message = OperationMessage(operation: Operation.catchLabel.rawValue, data: catchData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }
    
    /// プレイヤーの移動
    func shareMovePlayer() {
        if let playerData = ownPlayer?.makeEncodedPlayerData() {
            let message = OperationMessage(operation: Operation.movePlayer.rawValue, data: playerData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }
    /**
     message受けたときのパース
     */
    func operationMessageDecode(data: Data){
        let decoder = JSONDecoder()
        guard let decodedMessage = try? decoder.decode(OperationMessage.self, from: data) else { return }
        guard let operationType = Operation(rawValue: decodedMessage.operation) else { return }
        print(operationType.rawValue)
        let data = decodedMessage.data
        switch operationType {
        case .initalLabel:
            receiveInitalLabelOperation(data: data)
        case .moveLabel:
            receiveMoveLabelOperation(data: data)
        case .flickedLabel:
            receiveFlickedLabelOperation(data: data)
        case .catchLabel:
            receiveCatchLabelOperation(data: data)
        case .movePlayer:
            receiveMovePlayerOperation(data: data)
        }
    }

    /// ラベルの初期の共有
    private func receiveInitalLabelOperation(data: Data) {
        print("receiveInitalLabelOperation")
        let decoder = JSONDecoder()
        guard let labelDataArray: [BaseAppLabelData] = try? decoder.decode([BaseAppLabelData].self, from: data) else { return }
        fieldLabels.removeAll()
        labelDataArray.forEach {
            let labelData = $0
            let point = convertFromBasisPointToDirectionPoint(dir: direction!, from: labelData.position)
            let rect = CGRect(origin: CGPoint(x: point.x - BaseAppLabel.labelSize.width/2, y: point.y - BaseAppLabel.labelSize.height/2), size:
                BaseAppLabel.labelSize)
            let imgName = labelData.imageName
            let id = labelData.id
            let label = BaseAppLabel(frame: rect, imageName: imgName, id: id, flick: flick!)
            label.delegate = self
            //仮
            
            fieldLabels.append(label)
            print($0)
        }
        viewController?.addLabel()
    }

    /// ラベルの移動イベントを受け取った時の位置の更新
    private func receiveMoveLabelOperation(data: Data) {
        print("reloadLocation")
        guard let baseAppLabelData: BaseAppLabelData = try? JSONDecoder().decode(BaseAppLabelData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelData.id }.first
        if let label = label, let dir = direction {
            label.center = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelData.position)
        }
    }

    private func receiveFlickedLabelOperation(data: Data) {
        guard let baseAppLabelFlickedData: BaseAppLabelFlickedData = try? JSONDecoder().decode(BaseAppLabelFlickedData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelFlickedData.id }.first
        if let label = label, let dir = direction {
            let covertedEndPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelFlickedData.end)
//            label.moveLabelWithAnimation(start: label.midPoint, end: covertedEndPoint)
            label.layer.borderColor = UIColor.yellow.cgColor
            label.layer.borderWidth = 10

            label.startPoint = label.center
            label.endPoint = covertedEndPoint
            label.labelPoint = label.center
            label.superview?.bringSubview(toFront: label)
            label.shrinkLabel(point: label.center)
            label.goAndReturn()

        }
    }

    private func receiveCatchLabelOperation(data: Data) {
        guard let baseAppLabelCatchData: BaseAppLabelCatchData = try? JSONDecoder().decode(BaseAppLabelCatchData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelCatchData.id }.first
        if let label = label, let dir = direction {
            let covertedEndPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelCatchData.position)
            label.caught = true
            label.center = covertedEndPoint
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 10
            label.restoreLabel(point: label.center)
        }
    }
    
    private func receiveMovePlayerOperation(data: Data) {
        guard let playerData: PlayerData = try? JSONDecoder().decode(PlayerData.self, from: data) else { return }
        let player = players.filter{ $0.id == playerData.id }.first
        let position = convertFromDirectionPointToBasisPoint(dir: direction!, point: playerData.position)
        if let player = player {
            player.position = position
        } else {
            let newPlayer = Player(id: playerData.id, name: playerData.name, position: position, type: .other)
            players.append(newPlayer)
        }
    }
}

extension BaseApplicationManager: BaseAppLabelDelegate {
    func appLabel(touchesBegan label: BaseAppLabel) {
        viewController?.scrollLock()
        currentSelectedLabel = label
    }

    func appLabel(touchesMoved label: BaseAppLabel) {
        viewController?.scrollLock()
    }

    func appLabel(touchesEnded label: BaseAppLabel) {
//        viewController?.scrollUnlock()
        shareMoveLabel(label: label)
        currentSelectedLabel = nil
    }

    func appLabel(flickMoved label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        shareFlickedLabel(label: label, start: start, end: end)
        currentSelectedLabel = nil
    }
    func appLabel(caught label: BaseAppLabel, position: CGPoint){
        shareCatchLabel(label: label, position: position)
    }

}


extension BaseApplicationManager: MCManagerDelegate {
    func mcManager(manager: MCManager, session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected")
//            initalizeShareAllLabel(to: peerID)
        default:
            break
        }
    }

    func mcManager(manager: MCManager, session: MCSession, didReceive data: Data, from peer: MCPeerID) {
        operationMessageDecode(data: data)
    }
}

extension BaseApplicationManager: SocketManagerDelegate {
    func manager(manager: SocketManager, scrollBy move: (Int, Int)) {
        if let currentSelectedLabel = currentSelectedLabel {
            currentSelectedLabel.frame.origin.x += move.0.cgFloat/11.7
            currentSelectedLabel.frame.origin.y += move.1.cgFloat/11.7
        }
        self.delegate?.appManager(manager: self, scroll: move)
    }
}
