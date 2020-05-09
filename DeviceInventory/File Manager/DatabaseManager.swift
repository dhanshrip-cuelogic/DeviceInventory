//
//  DatabaseManager.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 02/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import FirebaseDatabase
import CodableFirebase

class DatabaseManager {

    static let dbManager = DatabaseManager()
    var ref : DatabaseReference!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var deviceData = [DeviceDetails]()
    var issuedData = [IssuedDevices]()
    var successful : Bool?
//    var checkinDetails = [IssuedDevices]()
    
    private (set) var fetchedData : [DeviceDetails]? {
        didSet {
             NotificationCenter.default.post(name: Notification.Name(rawValue: "loadedPost"), object: nil)
        }
    }
    private (set) var issuedDeviceData : [IssuedDevices]? {
        didSet {
             NotificationCenter.default.post(name: Notification.Name(rawValue: "gotIssuedData"), object: nil)
        }
    }

    
    private init() {
           //
       }
    
     func createReference(){
        ref = Database.database().reference()
     }
    
     func decodingDeviceDetails(jsondata : Data?) -> [DeviceDetails]{
        let data = try! decoder.decode([String : DeviceDetails].self, from: jsondata!)
        if deviceData.count != 0 {
            deviceData.removeAll()
        }
        for device in data{
            deviceData.append(device.value)
        }
        return deviceData
     }
    
    func decodingIssuedDeviceData(jsondata : Data?) -> [IssuedDevices]{
       let data = try! decoder.decode([String : IssuedDevices].self, from: jsondata!)
        if issuedData.count != 0 {
            issuedData.removeAll()
        }
       for device in data{
           issuedData.append(device.value)
       }
       return issuedData
    }

    
    func takeSnapshotOfDeviceTable() {
        ref.child("DeviceTable").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            let model = try? JSONSerialization.data(withJSONObject: value)
            
            guard let data = Data(base64Encoded: model!.base64EncodedData()) else { return }
            if self.fetchedData != nil {
                self.fetchedData?.removeAll()
            }
            self.fetchedData = self.decodingDeviceDetails(jsondata: data)
        })
    }
    
    func takeSnapshotOfIssuedDeviceTable() {
        ref.child("IssuedDeviceTable").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            let model = try? JSONSerialization.data(withJSONObject: value)
            
            guard let data = Data(base64Encoded: model!.base64EncodedData()) else { return }
            if self.issuedDeviceData != nil {
                self.issuedDeviceData?.removeAll()
            }
            self.issuedDeviceData = self.decodingIssuedDeviceData(jsondata: data)
        })
    }
    
    func addNewDevice(deviceID : String, modelName : String, platform : String, osVersion : String) {
        ref.child("DeviceTable").child(deviceID).setValue(["DeviceID" : deviceID,"ModelName" : modelName,"Platform" : platform,"OSVersion" : osVersion, "Status" : "Available"]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func updateDatabase(with id: String, modelName : String, platform : String, osVersion : String, status : String) {
        ref.child("DeviceTable/\(id)").setValue(["DeviceID" : id,"ModelName" : modelName,"Platform" : platform,"OSVersion" : osVersion, "Status" : status]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func deleteFromDatabase(with id: String) {
        let removingID = ref.child("DeviceTable").child(id)
        removingID.removeValue { (error, ref) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func addNewCheckIn(cueID : String, deviceID : String, date : String, checkin : String) {
        ref.child("IssuedDeviceTable").child(deviceID).setValue(["CueID" : cueID, "DeviceID" : deviceID, "Date" : date, "Checkin" : checkin, "Checkout" : "-- : --", "Status" : "Issued"]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func addCheckOut(cueID : String, deviceID : String, date : String, checkin : String, checkout : String) {
        ref.child("IssuedDeviceTable").child(deviceID).setValue(["CueID" : cueID, "DeviceID" : deviceID, "Date" : date, "Checkin" : checkin, "Checkout" : checkout, "Status" : "Available"]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func createNewUser(cueID : String, email : String) {
        ref.child("EmployeeTable").child(cueID).setValue(["CueID" : cueID, "Email" : email]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func updateDeviceStatusAfterCheckin(of deviceID: String) {
        ref.child("DeviceTable").child(deviceID).child("Status").setValue("Issued")
    }
    
    func updateDeviceStatusAfterCheckout(of deviceID: String) {
        ref.child("DeviceTable").child(deviceID).child("Status").setValue("Available")
    }
//
//    func fetchCheckInDetails(deviceid :  String) {
//        ref.child("IssuedTable").child(deviceid).observeSingleEvent(of: .value) { snapshot in
//            guard let value = snapshot.value else { return }
//            let model = try? JSONSerialization.data(withJSONObject: value)
//
//            guard let data = Data(base64Encoded: model!.base64EncodedData()) else { return }
//            if self.checkinDetails != nil {
//                self.checkinDetails.removeAll()
//            }
//            self.checkinDetails = self.decodingIssuedDeviceData(jsondata: data)
//        }
//    }
    
}
