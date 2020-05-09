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
    
    let deviceListPresenter = DeviceListForEmployeePresenter()
    let sectionNames = ["Available","Issued"]
    var resultData: [DeviceDetails] = []
    var availableDevices = [DeviceDetails]()
    var issuedDevices = [DeviceDetails]()
    var devicesToDisplay = [[DeviceDetails]]()
    var sortedList : [DeviceDetails] = []
    var platform : Platform?
    var indexOfSelectedRow : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        deviceListPresenter.databaseReference()
        deviceListPresenter.devicesBasedOnStatus()
        devicesToDisplay = [availableDevices, issuedDevices]
        
        // It will send notification after reading data from firebase and it will call reloadtable() to perform action on this notification.
        NotificationCenter.default.addObserver(self, selector: Selector(("reloadTable")), name: NSNotification.Name(rawValue: "loadedPost"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        deviceListPresenter.databaseReference()
    }
    
    // Here we are sorting devices according to the status i.e., available or issued to display device in respective section.
    func setDevicesBasedOnStatus() {
        if availableDevices.count != 0 || issuedDevices.count != 0 {
            availableDevices.removeAll()
            issuedDevices.removeAll()
        }
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
        if sortedList.count != 0 {
            sortedList.removeAll()
        }
        sortedList = deviceListPresenter.SortByPlatform()
        deviceListPresenter.devicesBasedOnStatus()
        tableView.reloadData()
    }
    
    func transitionToDisplayDevice(at index: IndexPath) {
        indexOfSelectedRow = index
        performSegue(withIdentifier: "redirectToDisplayDetailsPage", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Here we will take all the details of selected indexpath and pass those details to the DisplayDevicePage.
        let displayDetailsPage = segue.destination as! DisplayDetailsPage
        displayDetailsPage.deviceID = devicesToDisplay[indexOfSelectedRow!.section][indexOfSelectedRow!.row].DeviceID
        displayDetailsPage.modelName =  devicesToDisplay[indexOfSelectedRow!.section][indexOfSelectedRow!.row].ModelName
        displayDetailsPage.platform =  devicesToDisplay[indexOfSelectedRow!.section][indexOfSelectedRow!.row].Platform
        displayDetailsPage.osVersion =  devicesToDisplay[indexOfSelectedRow!.section][indexOfSelectedRow!.row].OSVersion
        displayDetailsPage.status = devicesToDisplay[indexOfSelectedRow!.section][indexOfSelectedRow!.row].Status
    }
    
    // Removing observer.
    deinit {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loadedPost"), object: self)
    }
}

extension DeviceListForEmployee {
    
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellForEmployee")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "CellForEmployee")
        }
        cell?.textLabel?.text = devicesToDisplay[indexPath.section][indexPath.row].ModelName
        return cell!
    }
}

extension DeviceListForEmployee {
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // It will call a function from presenter to perform action on selected row.
        deviceListPresenter.displaySelectedDevice(at: indexPath)
    }
}
