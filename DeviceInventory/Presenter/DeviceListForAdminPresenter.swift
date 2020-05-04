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
//    func setDevicesBasedOnStatus()
//    func reloadTable()
}

class DeviceListForAdminPresenter {
    
    var deviceListDelegate : DeviceListForAdminProtocol?
    var fetchedData = [DeviceDetails]()
   
    // Creating database reference to fetch data of DeviceTable from database.
    func databaseReference() {
        DatabaseManager.dbManager.createReference()
    }
    
    // This function is to get fetched data from DatabaseManager and returning array of data according to the selected platform.
    func SortByPlatform() -> [DeviceDetails]{
//        fetchedData.removeAll()
        fetchedData = DatabaseManager.dbManager.fetchedData!
//        deviceListDelegate!.resultData = []
        for device in fetchedData {
            if device.Platform == deviceListDelegate?.platform?.rawValue {
                deviceListDelegate?.resultData.append(device)
            }
        }
        return deviceListDelegate!.resultData
    }

}
