//
//  DeviceListForAdmin.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceListForAdmin: CustomNavigationController, DeviceListForAdminProtocol, CellProtocol {

    @IBOutlet weak var tableview: UITableView!
    
    let deviceListPresenter = DeviceListForAdminPresenter()
    var sortedList : [DeviceDetails] = []
    var platform : Platform?
    var performEdit : Bool = false
    var indexForEditing : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        tableview.delegate = self
        tableview.dataSource = self
        prepareForLoading()
    }
    
    func prepareForLoading() {
        navigationItem.title = "Device List"
        navigationItem.leftBarButtonItem = backButton()
        navigationItem.rightBarButtonItems = [addButton(selector: #selector(redirectToDeviceDetailsPage)), logoutButton()]
        
        //Registering custom cell with nib.
        let cellNib = UINib(nibName: "TableViewCell", bundle: nil)
        tableview.register(cellNib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performEdit = false
        if sortedList.count != 0 {
            sortedList.removeAll()
        }
        deviceListPresenter.SortByPlatform()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadTable()
    }
        
    // This function will call presenter to get data according to the selected platform and reload data.
    func reloadTable() {
        tableview.reloadData()
    }
    
    @objc func redirectToDeviceDetailsPage() {
        let deviceDetailPage = self.storyboard!.instantiateViewController(withIdentifier: "DeviceDetailsPage") as! DeviceDetailsPage
        
        // Prepare for transition to auto populate the field of device display page only when we will edit data.
        if performEdit == true {
            guard let index = indexForEditing else { return }
            deviceDetailPage.deviceID = sortedList[index.row].DeviceID
            deviceDetailPage.modelName = sortedList[index.row].ModelName
            deviceDetailPage.platform = sortedList[index.row].Platform
            deviceDetailPage.osVersion = sortedList[index.row].OSVersion
            deviceDetailPage.status = sortedList[index.row].Status
            deviceDetailPage.performEditing = true
        } else {
            if platform == Platform.iOS {
                deviceDetailPage.platform = "iOS"
            }
        }
        self.navigationController?.pushViewController(deviceDetailPage, animated: false)
    }
    
    // On click of delete button it will call deleteData method of presenter.
    func whenDeleteButtonPressed(at index: IndexPath) {
        deviceListPresenter.deleteData(at: index)
    }
    
    // On click of edit button it will call editData method of presenter.
    func whenEditButtonPressed(at index: IndexPath) {
        performEdit = true
        indexForEditing = index
        redirectToDeviceDetailsPage()
    }
    
    // On successfull action of deleting or editing data it will show an successful alert.
    func showAlert() {
        let alert = UIAlertController(title: "Successfull", message: "Deleted data Succesfully", preferredStyle: .alert)
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
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
        
    }
    
}

extension DeviceListForAdmin : UITableViewDataSource{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.cellDelegate = self
        cell.index = indexPath
        cell.textLabel?.text = sortedList[indexPath.row].ModelName
        return cell
    }
}

extension DeviceListForAdmin : UITableViewDelegate{
    // Mark: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Perform segue to details device page.
    }
    
}
