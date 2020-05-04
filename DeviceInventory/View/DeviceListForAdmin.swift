//
//  DeviceListForAdmin.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceListForAdmin: UITableViewController, DeviceListForAdminProtocol {

    let deviceListPresenter = DeviceListForAdminPresenter()
    var resultData: [DeviceDetails] = []
    var sortedList : [DeviceDetails] = []
    var platform : Platform?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        deviceListPresenter.databaseReference()
        NotificationCenter.default.addObserver(self, selector: Selector(("reloadTable")), name: NSNotification.Name(rawValue: "loadedPost"), object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = sortedList[indexPath.row].ModelName
        return cell!
    }
    
    // This function will call presenter to get data according to the selected platform and reload data.
    @objc func reloadTable() {
        sortedList = deviceListPresenter.SortByPlatform()
        tableView.reloadData()
    }
    
    // Removing observer.
    deinit {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loadedPost"), object: self)
    }
}
