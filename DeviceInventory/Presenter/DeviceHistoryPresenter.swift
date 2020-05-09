//
//  DeviceHistoryPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol DeviceHistoryProtocol {
    var resultData : [IssuedDevices] {get set }
    var deviceID : String? {get set }
}

class DeviceHistoryPresenter {
    
    var deviceHistoryDelegate : DeviceHistoryProtocol?
    var issuedData : [IssuedDevices] = []
    
    // Creating database reference and fetching data of IssuedDeviceTable.
    func databaseReference() {
        DatabaseManager.dbManager.createReference()
        DatabaseManager.dbManager.takeSnapshotOfIssuedDeviceTable()
    }
    
    func sortByDeviceID() -> [IssuedDevices]{
        if issuedData.count != 0 {
            issuedData.removeAll()
        }
        issuedData = DatabaseManager.dbManager.issuedDeviceData!
        if deviceHistoryDelegate?.resultData.count != 0 {
            deviceHistoryDelegate?.resultData.removeAll()
        }
        for device in issuedData {
            if device.DeviceID == deviceHistoryDelegate!.deviceID! {
                deviceHistoryDelegate?.resultData.append(device)
            }
        }
        return deviceHistoryDelegate!.resultData
    }
}
