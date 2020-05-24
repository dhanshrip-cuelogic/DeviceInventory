//
//  DeviceListForEmployee.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DeviceListForEmployee: CustomNavigationController, DeviceListForEmployeeProtocol {
    
    @IBOutlet weak var tableview: UITableView!
    
    let deviceListPresenter = DeviceListForEmployeePresenter()
    let sectionNames = ["Available","Issued"]
    var availableDevices : [DeviceDetails] = []
    var issuedDevices : [DeviceDetails] = []
    var devicesToDisplay: [[DeviceDetails]] = []
    var platform : Platform?
    var issuedUserCueID : String?
    var currentUserCueID : String?
    var currentUserName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceListPresenter.deviceListDelegate = self
        tableview.delegate = self
        tableview.dataSource = self
        prepareForLoading()
    }
    
    func prepareForLoading() {
        self.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton()
        navigationItem.rightBarButtonItem = logoutButton()
        navigationItem.title = "Device List"
        devicesToDisplay = [availableDevices, issuedDevices]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if availableDevices.count != 0 || issuedDevices.count != 0 {
            availableDevices.removeAll()
            issuedDevices.removeAll()
        }
        deviceListPresenter.devicesBasedOnStatus()
    }
    
    func reloadTable() {
        devicesToDisplay = [availableDevices, issuedDevices]
        tableview.reloadData()
    }
    
    func transitionToDisplayDevice(at index: IndexPath) {
        let displayDetailsPage = self.storyboard!.instantiateViewController(withIdentifier: "redirectToDisplayDetailsPage") as! DisplayDetailsPage
        displayDetailsPage.deviceID = devicesToDisplay[index.section][index.row].DeviceID
        displayDetailsPage.modelName =  devicesToDisplay[index.section][index.row].ModelName
        displayDetailsPage.platform =  devicesToDisplay[index.section][index.row].Platform
        displayDetailsPage.osVersion =  devicesToDisplay[index.section][index.row].OSVersion
        displayDetailsPage.status = devicesToDisplay[index.section][index.row].Status
        self.navigationController?.pushViewController(displayDetailsPage, animated: false)
    }
}

extension DeviceListForEmployee : UITableViewDataSource{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesToDisplay[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellForEmployee")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CellForEmployee")
        }
        cell?.textLabel?.text = devicesToDisplay[indexPath.section][indexPath.row].ModelName
        return cell!
    }
    
    
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 35.0
    //    }
    //
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //
    //        let view = UIView()
    //        view.backgroundColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(180/255.0), blue: CGFloat(124/255.0), alpha: CGFloat(1.0))
    //
    //        let label = UILabel()
    //        label.text = sectionNames[section]
    //        label.frame = CGRect(x: 5, y: 5, width: 100, height: 35)
    //        label.textColor = UIColor.white
    //        view.addSubview(label)
    //        return view
    //    }
    
    
    //    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
    //        view.tintColor = UIColor(red: CGFloat(0/255.0), green: CGFloat(180/255.0), blue: CGFloat(124/255.0), alpha: CGFloat(1.0) )
    //        let header = view as! UITableViewHeaderFooterView
    //        header.textLabel?.textColor = UIColor.white
    //    }
    
}

extension DeviceListForEmployee : UITableViewDelegate{
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // It will call a function from presenter to perform action on selected row.
        transitionToDisplayDevice(at : indexPath)
        
    }
}
