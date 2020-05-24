//
//  DeviceListForEmployeePresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 30/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

protocol DeviceListForEmployeeProtocol {
    var platform : Platform? {get set}
    var availableDevices : [DeviceDetails] {get set}
    var issuedDevices : [DeviceDetails] {get set}
    var devicesToDisplay : [[DeviceDetails]] {get set}
    func reloadTable()
    func transitionToDisplayDevice(at index : IndexPath)
}

class DeviceListForEmployeePresenter {
    
    var deviceListDelegate : DeviceListForEmployeeProtocol?
    var currentDeviceID : String?
    
    // Here we are passing this function to DeviceListForEmployee page to perform sorting based on status.
    func devicesBasedOnStatus() {
        DatabaseManager.shared.takeSnapshotOfDeviceTable { (sortedList) in
            var availableList : [DeviceDetails]  = []
            var issuedList : [DeviceDetails] = []
            for device in sortedList! {
                if device.Platform == self.deviceListDelegate?.platform!.rawValue {
                    if device.Status == "Available" {
                        availableList.append(device)
                    }else {
                        issuedList.append(device)
                    }
                }
            }
            self.deviceListDelegate?.availableDevices = availableList
            self.deviceListDelegate?.issuedDevices = issuedList
            
            self.deviceListDelegate?.reloadTable()
        }
    }
   
}
