//
//  DeviceDetailsPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 05/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import Firebase

protocol DeviceDetailsProtocol {
    var errorLabel : UILabel? { get set }
    func showAlert()
}

class DeviceDetailsPresenter {
    
    var deviceDetailDelegate : DeviceDetailsProtocol?
    var deviceID : String?
    var modelName : String?
    var platform : String?
    var osVersion : String?
    var status : String?
    var performEditing : Bool?
    
    // Here we will create reference to database and will set new values into database.
    func saveButtonClicked() {
        DatabaseManager.dbManager.createReference()
        
        if performEditing == true {
            DatabaseManager.dbManager.updateDatabase(with: deviceID!, modelName: modelName!, platform: platform!, osVersion: osVersion!, status : status!)
            if DatabaseManager.dbManager.successful == true {
                deviceDetailDelegate?.showAlert()
            }else {
                showError("Could not update device data.")
            }
        } else {
            DatabaseManager.dbManager.addNewDevice(deviceID: deviceID!, modelName: modelName!, platform: platform!, osVersion: osVersion!)
            if DatabaseManager.dbManager.successful == true {
                deviceDetailDelegate?.showAlert()
            }else {
                showError("Could not save new device data.")
            }
        }
        
    }
    
    func showError(_ message : String) {
        deviceDetailDelegate?.errorLabel?.text = message
        deviceDetailDelegate?.errorLabel?.alpha = 1
    }
}
