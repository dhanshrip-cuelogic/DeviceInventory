//
//  PlatformSelectionPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class PlatformSelectionPage: CustomNavigationController, PlatformSelectionProtocol {
    
    @IBOutlet weak var tableview: UITableView!
    
    let platformSelectionPresenter = PlatformSelectionPresenter()
    var user : User?
    var platform : Platform?
    
    let rows = ["Android", "iOS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        platformSelectionPresenter.platformSelectionDelegate = self
        initUI()
    }
    
    func initUI() {
        navigationItem.title = "Platform Selection"
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = logoutButton()
    }
    
    func performTransitionToShowDeviceList() {
        if user == .admin {
            redirectToDeviceListForAdmin()
        }else {
            redirectToDeviceListForEmployee()
        }
    }
    
    func redirectToDeviceListForAdmin() {
        let adminList = self.storyboard!.instantiateViewController(withIdentifier: "deviceListForAdmin") as! DeviceListForAdmin
        adminList.platform = platform
        adminList.user = user
        self.navigationController?.pushViewController(adminList, animated: false)
    }
    
    func redirectToDeviceListForEmployee() {
        let employeeList = self.storyboard!.instantiateViewController(withIdentifier: "deviceListForEmployee") as! DeviceListForEmployee
        employeeList.platform = platform
        employeeList.user = user
        self.navigationController?.pushViewController(employeeList, animated: false)
    }
}

extension PlatformSelectionPage : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = rows[indexPath.row]
        return cell!
    }
}

extension PlatformSelectionPage : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            platform = .android
            performTransitionToShowDeviceList()
        }
        else if indexPath.row == 1 {
            platform = .iOS
            performTransitionToShowDeviceList()
        }
    }
}
