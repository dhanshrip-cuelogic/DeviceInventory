//
//  DeviceListForAdminPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

import Foundation
import FirebaseDatabase

protocol DeviceListForAdminProtocol {
    var resultData : [DeviceDetails] { get set }
    var platform : Platform? {get set}
    func transitionToDeviceDetailsPage()
    func showAlert()
    func showErrorAlert()
}

class DeviceListForAdminPresenter {
    
    var deviceListDelegate : DeviceListForAdminProtocol?
    var fetchedData = [DeviceDetails]()
   
    // Creating database reference to fetch data of DeviceTable from database.
    func databaseReference() {
        DatabaseManager.dbManager.createReference()
        DatabaseManager.dbManager.takeSnapshotOfDeviceTable()
    }
    
    // This function is to get fetched data from DatabaseManager and returning array of data according to the selected platform.
    func SortByPlatform() -> [DeviceDetails]{
        if fetchedData.count != 0 {
            fetchedData.removeAll()
        }
        fetchedData = DatabaseManager.dbManager.fetchedData!
        if deviceListDelegate?.resultData.count != 0 {
            deviceListDelegate?.resultData.removeAll()
        }
        for device in fetchedData {
            if device.Platform == deviceListDelegate?.platform?.rawValue {
                deviceListDelegate?.resultData.append(device)
            }
        }
        return deviceListDelegate!.resultData
    }
    
    // It will make transition to Device Details Page.
    func whenAddDeviceButtonClicked() {
        deviceListDelegate?.transitionToDeviceDetailsPage()
    }
    
    // It will take the deviceId as argument and call delete function from DatabaseManager.
    func deleteData(at index : IndexPath) {
        let id = deviceListDelegate?.resultData[index.row].DeviceID
//        DatabaseManager.dbManager.takeSnapshotOfUpdatedDeviceTable()
        DatabaseManager.dbManager.deleteFromDatabase(with: id!)
        if DatabaseManager.dbManager.successful == true {
            deviceListDelegate!.showAlert()
        }else {
            deviceListDelegate?.showErrorAlert()
        }
    }

    // When edit button is clicked it will transit to device details page and will auto populate its data for editing.
    func editButtonClicked() {
        deviceListDelegate?.transitionToDeviceDetailsPage()
    }
}
