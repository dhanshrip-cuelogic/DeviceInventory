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
    var platform : Platform? {get set}
    var sortedList : [DeviceDetails] {get set}
    func showAlert()
    func showErrorAlert()
    func reloadTable()
    
}

class DeviceListForAdminPresenter {
    
    var deviceListDelegate : DeviceListForAdminProtocol?
    
    // This function is to get fetched data from DatabaseManager and returning array of data according to the selected platform.
    func SortByPlatform() {
        DatabaseManager.shared.takeSnapshotOfDeviceTable { (fetchedData) in
            var resultData : [DeviceDetails] = []
            for device in fetchedData! {
                if device.Platform == self.deviceListDelegate?.platform?.rawValue {
                    resultData.append(device)
                }
            }
            self.deviceListDelegate?.sortedList = resultData
            self.deviceListDelegate?.reloadTable()
        }
    }
    
    // It will take the deviceId as argument and call delete function from DatabaseManager.
    func deleteData(at index : IndexPath) {
        guard let id = deviceListDelegate?.sortedList[index.row].DeviceID else { return }
        DatabaseManager.shared.deleteFromDatabase(with: id)
        if DatabaseManager.shared.successful == true {
            deviceListDelegate?.showAlert()
        }else {
            deviceListDelegate?.showErrorAlert()
        }
    }
}
