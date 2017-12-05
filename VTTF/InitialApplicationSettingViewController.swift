//
//  InitialApplicationSettingViewController.swift
//  ColorCoordinate
//
//  Created by Yuki Takeda on 2017/10/30.
//  Copyright © 2017年 teakun. All rights reserved.
//

import UIKit

enum AppType: String {
    case monitoring = "モニタリング"
    case labelapp = "ラベル動かし"
}

extension AppType: EnumEnumerable {}
extension RoleInApp: EnumEnumerable {}

class InitialApplicationSettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    private let cellIdentifer = "InitialApplicationSettingViewControllerCell"
    
    private var role: RoleInApp?
    private var app: AppType?
    private var direction: Direction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "起動時初期設定"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showAlertChoiceRole() {
        let alert = UIAlertController(title: "役割を選択してください", message: "", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRectMake(0, 0, self.view.bounds.width/2, self.view.bounds.height/2)
            popoverController.permittedArrowDirections = .any
        }

        for item in RoleInApp.cases {
            let action = UIAlertAction(title: item.rawValue, style: .default, handler: { _ in
                self.role = item
                self.tableView.reloadData()
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertChoiceApp() {
        let alert = UIAlertController(title: "アプリケーションを選択してください", message: "", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRectMake(0, 0, self.view.bounds.width/2, self.view.bounds.height/2)
            popoverController.permittedArrowDirections = .any
        }

        for item in AppType.cases {
            let action = UIAlertAction(title: item.rawValue, style: .default, handler: { _ in
                self.app = item
                self.tableView.reloadData()
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertChoiceDirection() {
        let alert = UIAlertController(title: "初期方向を選択してください", message: "", preferredStyle: .actionSheet)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRectMake(0, 0, self.view.bounds.width/2, self.view.bounds.height/2)
            popoverController.permittedArrowDirections = .any
        }

        for item in Direction.cases {
            let action = UIAlertAction(title: item.rawValue, style: .default, handler: { _ in
                self.direction = item
                self.tableView.reloadData()
            })
            alert.addAction(action)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func didTouchUpStartButton(_ sender: UIButton) {
        guard let app = app else { return }
        guard let role = role else { return }
        guard let direction  = direction else { return }
        
        switch app {
        case .monitoring:
            break;
//            self.navigationController?.pushViewController(MonitoringViewController.instantiate(), animated: true)
        case .labelapp:
            let vc = BaseApplicationViewController()
            BaseApplicationManager.sharedInstance.setupInitialSetting(role: role, dir: direction, vc: vc)
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}

extension InitialApplicationSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifer) ?? UITableViewCell(style: .value2, reuseIdentifier: cellIdentifer)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "起動するApp"
            cell.detailTextLabel?.text = app?.rawValue
        case 1:
            cell.textLabel?.text = "役割"
            cell.detailTextLabel?.text = role?.rawValue
        case 2:
            cell.textLabel?.text = "初期位置"
            cell.detailTextLabel?.text = direction?.rawValue
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
}

extension InitialApplicationSettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            showAlertChoiceApp()
        case 1:
            showAlertChoiceRole()
        case 2:
            showAlertChoiceDirection()
        default:
            break
        }

    }

    
}
