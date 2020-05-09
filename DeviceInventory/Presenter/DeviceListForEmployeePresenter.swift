//
//  DeviceListForEmployeePresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DeviceListForEmployeeProtocol {
    var resultData : [DeviceDetails] { get set }
    var platform : Platform? {get set}
    func setDevicesBasedOnStatus()
    func transitionToDisplayDevice(at index : IndexPath)
}

class DeviceListForEmployeePresenter {
    
    var deviceListDelegate : DeviceListForEmployeeProtocol?
    var fetchedData = [DeviceDetails]()
   
    // Here we are creating reference of the database to fetch data from the table.
    func databaseReference() {
        DatabaseManager.dbManager.createReference()
        DatabaseManager.dbManager.takeSnapshotOfDeviceTable()
    }
    
    // Here we are passing this function to DeviceListForEmployee page to perform sorting based on status.
    func devicesBasedOnStatus() {
        deviceListDelegate?.setDevicesBasedOnStatus()
    }
    
    // Here we are filtering and storing data according to the selected platform to work with it.
    func SortByPlatform() -> [DeviceDetails]{
        if fetchedData.count != 0 {
            fetchedData.removeAll()
        }
       fetchedData = DatabaseManager.dbManager.fetchedData!
        
       if deviceListDelegate?.resultData.count != 0 {
            deviceListDelegate?.resultData.removeAll()
        }
       for device in fetchedData {
           if device.Platform == deviceListDelegate!.platform!.rawValue {
               deviceListDelegate?.resultData.append(device)
           }
       }
       return deviceListDelegate!.resultData
    }
    
    // It will take the indexpath of the selected row and it will show the details on device details page.
    func displaySelectedDevice(at index: IndexPath) {
        // Here we will take all the details of selected indexpath and pass those details to the DisplayDevicePage.
        deviceListDelegate?.transitionToDisplayDevice(at : index)
        
    }
    
}
