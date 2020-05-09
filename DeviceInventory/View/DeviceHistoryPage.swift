//
//  DeviceHistoryPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceHistoryPage: UITableViewController, DeviceHistoryProtocol {
        
    var deviceHistoryPresenter = DeviceHistoryPresenter()
    var deviceID : String?
    var issuedDevices : [IssuedDevices] = []
    var resultData : [IssuedDevices] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceHistoryPresenter.deviceHistoryDelegate = self
        deviceHistoryPresenter.databaseReference()
        
        //Registering custom cell with nib.
        let cellNib = UINib(nibName: "DeviceHistoryCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "deviceHistoryCell")
        
        // It will send notification after reading data from firebase and it will call reloadtable() to perform action on this notification.
        NotificationCenter.default.addObserver(self, selector: #selector(DeviceListForAdmin.reloadTable), name: NSNotification.Name(rawValue: "gotIssuedData"), object: nil)
    }
    
    // This function will call presenter to get data according to the selected platform and reload data.
    @objc func reloadTable() {
        if issuedDevices.count != 0 {
            issuedDevices.removeAll()
        }
        issuedDevices = deviceHistoryPresenter.sortByDeviceID()
        tableView.reloadData()
    }

    // Removing observer.
    deinit {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "gotIssuedData"), object: self)
    }

}

extension DeviceHistoryPage {
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issuedDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 100
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceHistoryCell", for: indexPath) as! DeviceHistoryCell
        cell.CueIDLabel.text = issuedDevices[indexPath.row].CueID
        cell.DateLabel.text = issuedDevices[indexPath.row].Date
        cell.CheckinLabel.text = issuedDevices[indexPath.row].Checkin
        cell.CheckoutLabel.text = issuedDevices[indexPath.row].Checkout
        return cell
    }
}
