//
//  DisplayDevicePresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol DisplayDeviceProtocol {
    func showAlert()
    func showAlertAfterCheckout()
    func showErrorAlert(title : String, message : String)
    var issuedUserCueID : String? {get set}
    var currentUserCueID : String? {get set}
    var currentUserName : String? {get set}
}

class DisplayDevicePresenter {
    
    var displayDelegate : DisplayDeviceProtocol?
    var currentDeviceID : String?
    var childid : String = ""
    
    func whenCheckinButtonIsClicked(childID : String, cueID : String,name : String, deviceID : String, date : Date, checkin : String) {
        // This will call a method from DatabaseManager to save the checkin time with deviceID for logged in user.
        DatabaseManager.shared.addNewCheckIn(childID : childID, cueID: cueID, name : name, deviceID: deviceID, date: date, checkin: checkin)
        if DatabaseManager.shared.successful == true {
            // Change the status of that device in DeviceTable as well.
            DatabaseManager.shared.updateDeviceStatusAfterCheckin(of: deviceID)
            displayDelegate?.showAlert()
        }else {
            DatabaseManager.shared.deleteFromIssuedTable(with: childID)
            displayDelegate?.showErrorAlert(title: "Failed", message: "Failed to Checkin Device.")
        }
    }
    
    func whenCheckoutButtonIsClicked(deviceID : String, checkout : String) {
        // This will call a method from DatabaseManager to save checkout time of that device.
        DatabaseManager.shared.takeSnapshotOfIssuedDeviceTable { (checkedInDetails) in
            var checkedinDeviceDetails : IssuedDevices?
            var keyIndex = 0
            
            for device in checkedInDetails! {
                if device.DeviceID == deviceID {
                    if device.Checkout == "-- : --" {
                        checkedinDeviceDetails = device
                        self.childid = DatabaseManager.shared.keys[keyIndex]
                    }
                }
                keyIndex += 1
            }
            guard let device = checkedinDeviceDetails else { return }
            //            let childid = self.getChildID(date: device.Date)
            
            DatabaseManager.shared.addCheckOut(childID: self.childid, cueID: device.CueID, name: device.Name, deviceID: deviceID, date: device.Date, checkin: device.Checkin, checkout: checkout)
            
            if DatabaseManager.shared.successful == true {
                // Change the status of that device in DeviceTable as well.
                DatabaseManager.shared.updateDeviceStatusAfterCheckout(of: deviceID)
                self.displayDelegate?.showAlertAfterCheckout()
            }else {
                self.displayDelegate?.showErrorAlert(title: "Failed", message: "Failed to Checkout Device.")
            }
        }
    }
    
    func getCurrentUser(completionHandler : @escaping (String?,String?)->()) {
        // This will call a method from DatabaseManager to save checkout time of that device.
        let user = Auth.auth().currentUser
        var userID : String = ""
        var userName : String = ""
        DatabaseManager.shared.takeSnapshotOfEmployeeDetails { (employeeDetails) in

            for employee in employeeDetails! {
                if employee.Email == user?.email {
//                    self.displayDelegate?.currentUserCueID = employee.CueID
//                    self.displayDelegate?.currentUserName = employee.Username
                    userID = employee.CueID
                    userName = employee.Username
                    completionHandler(userID,userName)
                } else {
                    completionHandler(nil,nil)
                }
            }
        }
    }
    
    func getIssuedUser(completionHandler : @escaping (String?)->()) {
        var issuedBy : String = ""
        DatabaseManager.shared.takeSnapshotOfIssuedDeviceTable { (issuedDevices) in
                for device in issuedDevices! {
                    if device.DeviceID == self.currentDeviceID {
    //                    self.displayDelegate?.issuedUserCueID = device.CueID
                        issuedBy = device.CueID
                        completionHandler(issuedBy)
                    } else {
                        completionHandler(nil)
                    }
                }
        }
    }
    
    // function to get date component from calender.
    func getDateAndTime() -> (date : Date, time : String, childID : String){
        let presentDate = Date()
        let calender = Calendar.current
        let component = calender.dateComponents([.year, .month, .day, .hour, .minute], from: presentDate)
        let childID = "\(component.day!)\(component.month!)\(component.year!)\(component.hour!)\(component.minute!)"
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm"
        let convertedTime = dateFormatter.string(from: presentDate)
        
        return (presentDate, convertedTime, childID)
    }
}
