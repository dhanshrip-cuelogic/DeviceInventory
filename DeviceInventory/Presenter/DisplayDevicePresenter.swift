//
//  DisplayDevicePresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol DisplayDeviceProtocol {
    func showAlert()
    func showAlertAfterCheckout()
    func showErrorAlert()
}

class DisplayDevicePresenter {
    
    var displayDelegate : DisplayDeviceProtocol?
    var checkedInDetails : [IssuedDevices]?
    var checkedinDeviceDetails : IssuedDevices?
    
    func databaseReference() {
        DatabaseManager.dbManager.createReference()
        DatabaseManager.dbManager.takeSnapshotOfIssuedDeviceTable()
    }
    
    func whenCheckinButtonIsClicked(cueID : String, deviceID : String, date : String, checkin : String) {
        // This will call a method from DatabaseManager to save the checkin time with deviceID for logged in user.
        DatabaseManager.dbManager.addNewCheckIn(cueID: cueID, deviceID: deviceID, date: date, checkin: checkin)
        if DatabaseManager.dbManager.successful == true {
            // Change the status of that device in DeviceTable as well.
            DatabaseManager.dbManager.updateDeviceStatusAfterCheckin(of: deviceID)
            displayDelegate!.showAlert()
        }else {
            displayDelegate!.showErrorAlert()
        }
    }
    
    func whenCheckoutButtonIsClicked(deviceID : String, checkout : String) {
        // This will call a methos from DatabaseManager to save checkout time of that device.
        checkedInDetails = DatabaseManager.dbManager.issuedDeviceData!

        for device in checkedInDetails! {
            if device.DeviceID == deviceID {
                checkedinDeviceDetails = device
            }
        }
        DatabaseManager.dbManager.addCheckOut(cueID: checkedinDeviceDetails!.CueID, deviceID: deviceID, date: checkedinDeviceDetails!.Date, checkin: checkedinDeviceDetails!.Checkin, checkout: checkout)
        
        if DatabaseManager.dbManager.successful == true {
            // Change the status of that device in DeviceTable as well.
            DatabaseManager.dbManager.updateDeviceStatusAfterCheckout(of: deviceID)
            displayDelegate!.showAlertAfterCheckout()
        }else {
            displayDelegate!.showErrorAlert()
        }
    }
    
}
