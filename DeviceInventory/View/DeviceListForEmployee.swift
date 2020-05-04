//
//  DeviceListForEmployee.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DeviceListForEmployee: UITableViewController, DeviceListForEmployeeProtocol {
    
    var resultData: [DeviceDetails] = []
    let deviceListPresenter = DeviceListForEmployeePresenter()
    let sectionNames = ["Available","Issued"]
    var availableDevices = [DeviceDetails]()
    var issuedDevices = [DeviceDetails]()
    var devicesToDisplay = [[DeviceDetails]]()
    var sortedList : [DeviceDetails] = []
    var platform : Platform?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        deviceListPresenter.databaseReference()
        deviceListPresenter.devicesBasedOnStatus()
        devicesToDisplay = [availableDevices, issuedDevices]
        
        // It will send notification after reading data from firebase and it will call reloadtable() to perform action on this notification.
        NotificationCenter.default.addObserver(self, selector: Selector(("reloadTable")), name: NSNotification.Name(rawValue: "loadedPost"), object: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesToDisplay[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = devicesToDisplay[indexPath.section][indexPath.row].ModelName
        return cell!
    }
    
    // Here we are sorting devices according to the status i.e., available or issued to display device in respective section.
    func setDevicesBasedOnStatus() {
        for device in sortedList {
            let status = device.Status
            if status == "Available" {
            availableDevices.append(device)
            }else {
                issuedDevices.append(device)
            }
            devicesToDisplay = [availableDevices, issuedDevices]
        }
    }
    
    // This is called after getting notification from DatabaseManager file.
    @objc func reloadTable() {
//        sortedList.removeAll()
        sortedList = deviceListPresenter.SortByPlatform()
        deviceListPresenter.devicesBasedOnStatus()
        tableView.reloadData()
    }
    
    // Removing observer.
    deinit {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loadedPost"), object: self)
    }
    
}
