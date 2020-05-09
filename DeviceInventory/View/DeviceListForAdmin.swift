//
//  DeviceListForAdmin.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceListForAdmin: UITableViewController, DeviceListForAdminProtocol, CellProtocol {

    let deviceListPresenter = DeviceListForAdminPresenter()
    var resultData: [DeviceDetails] = []
    var sortedList : [DeviceDetails] = []
    var platform : Platform?
    var performEdit : Bool = false
    var indexForEditing : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        deviceListPresenter.databaseReference()
        
        //Registering custom cell with nib.
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        
        // It will send notification after reading data from firebase and it will call reloadtable() to perform action on this notification.
        NotificationCenter.default.addObserver(self, selector: #selector(DeviceListForAdmin.reloadTable), name: NSNotification.Name(rawValue: "loadedPost"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performEdit = false
        deviceListPresenter.databaseReference()
    }
        
    // This function will call presenter to get data according to the selected platform and reload data.
    @objc func reloadTable() {
        if sortedList.count != 0 {
            sortedList.removeAll()
        }
        sortedList = deviceListPresenter.SortByPlatform()
        tableView.reloadData()
    }
    
    @IBAction func AddDeviceButton(_ sender: UIBarButtonItem) {
        deviceListPresenter.whenAddDeviceButtonClicked()
    }
    
    // Perform segue from device list to Add new device page
    func transitionToDeviceDetailsPage() {
        performSegue(withIdentifier: "redirectToDeviceDetailsPage", sender: self)
    }
    
    // Prepare for transition to auto populate the field of device display page only when we will edit data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if performEdit == true {
            let deviceDetailPage = segue.destination as! DeviceDetailsPage
            deviceDetailPage.deviceID = sortedList[(indexForEditing?.row)!].DeviceID
            deviceDetailPage.modelName = sortedList[(indexForEditing?.row)!].ModelName
            deviceDetailPage.platform = sortedList[(indexForEditing?.row)!].Platform
            deviceDetailPage.osVersion = sortedList[(indexForEditing?.row)!].OSVersion
            deviceDetailPage.status = sortedList[(indexForEditing?.row)!].Status
            deviceDetailPage.performEditing = true
        }
    }
    
    // On click of delete button it will call deleteData method of presenter.
    func whenDeleteButtonPressed(at index: IndexPath) {
        deviceListPresenter.deleteData(at: index)
    }
    
    // On click of edit button it will call editData method of presenter.
    func whenEditButtonPressed(at index: IndexPath) {
        performEdit = true
        indexForEditing = index
        deviceListPresenter.editButtonClicked()
    }
    
    // On successfull action of deleting or editing data it will show an successful alert.
    func showAlert() {
        let alert = UIAlertController(title: "Successfull", message: "Saved data Succesfully", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (saveAction) in
            self.viewWillAppear(true)
        }
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    
    // If it fails to perform the operation it will sow an alert regarding the same.
    func showErrorAlert() {
        let alert = UIAlertController(title: "Failed", message: "Failed to perform operation", preferredStyle: .alert)
        let FailAction = UIAlertAction(title: "OK", style: .default) { (errorAction) in
            self.viewWillAppear(true)
//            self.reloadTable()
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // Removing observer.
    deinit {
          NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "loadedPost"), object: self)
    }
}

extension DeviceListForAdmin {
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.cellDelegate = self
        cell.index = indexPath
        cell.textLabel?.text = sortedList[indexPath.row].ModelName
        return cell
    }
}

extension DeviceListForAdmin {
    // Mark: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform segue to details device page.
    }
    
}
