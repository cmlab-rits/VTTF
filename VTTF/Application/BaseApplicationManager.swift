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
    func appManager(manager: BaseApplicationManager, initalize labels: [BaseAppLabel])
    func appManager(manager: BaseApplicationManager, add player: Player, view: UIView)
    func appManager(manager: BaseApplicationManager, longpress label: BaseAppLabel)
}

class BaseApplicationManager: NSObject {
    static let sharedInstance = BaseApplicationManager()

    private let mcManager = MCManager.sharedInstance

    private let socketManager = SocketManager.sharedInstance

    private var viewController: BaseApplicationViewController?

    private var ownPlayer: Player?

    var players: [Player] = []

    private var direction: Direction?
    
    private var role: RoleInApp?

    private var taskLabelCount: Int = 15

//    private var peerIdDictionary = [String:MCPeerID]()

    var delegate: BaseAppManagerDelegate?
    
    var fieldLabels: [BaseAppLabel] = []

    var playerPositionView: [UIView] = []

    var basisWorkspaceSize: CGSize = CGSize(width: 3500, height: 3500)

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
        if role == .leader {
            setupFieldObjects()
        }
    }
    
    func setupInitialSetting(role: RoleInApp, dir: Direction, vc: BaseApplicationViewController) {
        self.role = role
        self.direction = dir
        self.viewController = vc
        startApplication()
    }

    private func updateOwnPlayerPosition(point: CGPoint) {
        let basePoint = convertDirectionPointToBasisPoint(dir: direction!, point: point)
        ownPlayer?.position = basePoint
    }

    func getCurrentPositionInScrollView() -> CGPoint? {
        return viewController?.getCurrentPositionInScrollView()
    }

    /// 作業空間に配置するラベルをつくる
    private func setupFieldObjects() {
        for i in 0..<taskLabelCount {
            let rect = CGRect(origin: genarateRandomPointInWorkspaceCircle(), size: CGSize(200,200))
            let showNumber = KERand.minMaxRandInt(0, 9)
            let id = "baseapplabel:\(i)"
            let label = BaseAppLabel(frame: rect, number: showNumber, id: id)
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
            point.x = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.width)))
            point.y = CGFloat(KERand.minMaxRandInt(0, Int(workspaceSize.height)))
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
    func convertDirectionPointToBasisPoint(dir: Direction, point: CGPoint) -> CGPoint{
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
    func initalizeShareAllLabel(to peerID: MCPeerID){
        let labelDataArray = fieldLabels.flatMap{ $0.makeBaseAppLabel() }
        let encoder = JSONEncoder()

        do {
            let encoded = try encoder.encode(labelDataArray)
            let message = OperationMessage(operation: Operation.initalLabel.rawValue, data: encoded)
            if let data = message.encode() {
                mcManager.send(data: data, peer: peerID)
            }
        } catch {
            fatalError()
        }
    }
    /// ラベルの移動
    func shareMoveLabel(label: BaseAppLabel) {
        print("sharelabel")
        if let labelData = label.makeEncodedBaseAppLabelData() {
            let message = OperationMessage(operation: Operation.moveLabel.rawValue, data: labelData)
            if let data = message.encode() {
                mcManager.send(data: data)
            }
        }
    }

    /// フリックによるラベルの移動
    func shareFlickedLabel(label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        if let flickedData = label.makeEncodedBaseAppLabelFlickedData() {
            let message = OperationMessage(operation: Operation.flickedLabel.rawValue, data: flickedData)
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
        case .movePlayer:
            receiveMovePlayerOperation(data: data)
        }
    }

    /// ラベルの初期の共有
    private func receiveInitalLabelOperation(data: Data) {
        let decoder = JSONDecoder()
        guard let labelDataArray: [BaseAppLabelData] = try? decoder.decode([BaseAppLabelData].self, from: data) else { return }
        labelDataArray.map{ BaseAppLabel(frame: CGRect(origin: convertFromBasisPointToDirectionPoint(dir: self.direction!, from: $0.position), size: CGSize(200,200)), number: 0, id: $0.id) }
                      .forEach{ self.fieldLabels.append($0) }
        self.delegate?.appManager(manager: self, initalize: fieldLabels)
    }

    /// ラベルの移動イベントを受け取った時の位置の更新
    private func receiveMoveLabelOperation(data: Data) {
        guard let baseAppLabelData: BaseAppLabelData = try? JSONDecoder().decode(BaseAppLabelData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelData.id }.first
        if let label = label, let dir = direction {
            label.midPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelData.position)
        }
    }

    private func receiveFlickedLabelOperation(data: Data) {
        guard let baseAppLabelFlickedData: BaseAppLabelFlickedData = try? JSONDecoder().decode(BaseAppLabelFlickedData.self, from: data) else { return }
        let label = fieldLabels.filter{ $0.id == baseAppLabelFlickedData.id }.first
        if let label = label, let dir = direction {
            let covertedEndPoint = convertFromBasisPointToDirectionPoint(dir: dir, from: baseAppLabelFlickedData.end)
            label.moveLabelWithAnimation(start: label.midPoint, end: covertedEndPoint)
        }
    }

    private func receiveMovePlayerOperation(data: Data) {
        guard let playerData: PlayerData = try? JSONDecoder().decode(PlayerData.self, from: data) else { return }
        let player = players.filter{ $0.id == playerData.id }.first
        if let player = player {
            player.position = playerData.position
        } else {
            let newPlayer = Player(id: playerData.id, name: playerData.name, position: playerData.position, type: .other)
            players.append(newPlayer)
        }
    }
}

extension BaseApplicationManager: BaseAppLabelDelegate {
    func appLabel(touchesBegan label: BaseAppLabel) {
        viewController?.scrollLock()
    }

    func appLabel(touchesMoved label: BaseAppLabel) {
        viewController?.scrollLock()
    }

    func appLabel(touchesEnded label: BaseAppLabel) {
        viewController?.scrollUnlock()
        shareMoveLabel(label: label)
    }

    func appLabel(flickMoved label: BaseAppLabel, start: CGPoint, end: CGPoint) {
        shareFlickedLabel(label: label, start: start, end: end)
    }

    func appLabel(longPressed label: BaseAppLabel) {
        self.delegate?.appManager(manager: self, longpress: label)
    }
}

extension BaseApplicationManager: MCManagerDelegate {
    func mcManager(manager: MCManager, session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected")
            if role == .leader {
                initalizeShareAllLabel(to: peerID)
            }

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
        self.delegate?.appManager(manager: self, scroll: move)
    }
}



















