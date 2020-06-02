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
    var errorText : UILabel? { get set }
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
        let error = validate()
        if error != nil {
            showError(error!)
        } else {
            
            guard let deviceid = deviceID else { return }
            guard let modelname = modelName else { return }
            guard let platform = platform else { return }
            guard let os = osVersion else { return }
            if performEditing == true {
                guard let status = status else { return }
                DatabaseManager.shared.updateDatabase(with: deviceid, modelName: modelname, platform: platform, osVersion: os, status : status) { successful, error in
                    if successful == true {
                        self.deviceDetailDelegate?.showAlert()
                    }else {
                        self.showError(error!)
                    }
                }
            } else {
                DatabaseManager.shared.addNewDevice(deviceID: deviceid, modelName: modelname, platform: platform, osVersion: os) { successful, error in
                    if successful == true {
                        self.deviceDetailDelegate?.showAlert()
                    }else {
                        self.showError(error!)
                    }
                }
                
            }
        }
        
    }
    
    func showError(_ message : String) {
        deviceDetailDelegate?.errorText?.text = message
        deviceDetailDelegate?.errorText?.alpha = 1
    }
    
    func validate() -> String? {
        if deviceID == "" || modelName == "" || platform == "" || osVersion == "" {
            return "Please fill all details."
        }
        return nil
    }
    
    func getOSversion() -> String {
        let os = ProcessInfo().operatingSystemVersion
        return "\(os.majorVersion).\(os.minorVersion).\(os.patchVersion)"
    }
    
    func getModelName() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
}
