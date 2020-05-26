//
//  DatabaseManager.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 02/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import FirebaseDatabase
import CodableFirebase
import FirebaseFirestore

class DatabaseManager {

    static let shared = DatabaseManager()
    var ref : DatabaseReference!
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    var successful : Bool?
    var keys : [String] = []
    
    private init() {
           ref = Database.database().reference()
       }
    
     func decodingDeviceDetails(jsondata : Data?) -> [DeviceDetails]{
        let data = try! decoder.decode([String : DeviceDetails].self, from: jsondata!)
        var deviceData : [DeviceDetails] = []
        for device in data{
            deviceData.append(device.value)
        }
        return deviceData
     }
    
    func decodingIssuedDeviceData(jsondata : Data?) -> [IssuedDevices]{
       let data = try! decoder.decode([String : IssuedDevices].self, from: jsondata!)
       var issuedData = [IssuedDevices]()
        if keys.count != 0 {
            keys.removeAll()
        }
       for device in data {
            issuedData.append(device.value)
            keys.append(device.key)
       }
       return issuedData
    }

    
    func decodingEmployeeData(jsondata : Data?) -> [Employee] {
        let data = try! decoder.decode([String : Employee].self, from: jsondata!)
        var employeeData : [Employee] = []
        for device in data{
            employeeData.append(device.value)
        }
        return employeeData
    }

    
    func takeSnapshotOfDeviceTable(completionHandler : @escaping ([DeviceDetails]?) -> ()) {
        ref.child("DeviceTable").observeSingleEvent(of: .value, with: { snapshot in
            var fetchedData : [DeviceDetails] = []
            guard let value = snapshot.value else { return }
            guard let model = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            guard let data = Data(base64Encoded: model.base64EncodedData()) else { return }
            fetchedData = self.decodingDeviceDetails(jsondata: data)
            if fetchedData.isEmpty {
                completionHandler(nil)
            } else {
                completionHandler(fetchedData)
            }
        })
    }
    
    func takeSnapshotOfIssuedDeviceTable(completionHandler : @escaping ([IssuedDevices]?) -> ()) {
        ref.child("IssuedDeviceTable").observeSingleEvent(of: .value, with: { snapshot in
            var issuedDeviceData : [IssuedDevices] = []
            guard let value = snapshot.value else { return }
            guard let model = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            guard let data = Data(base64Encoded: model.base64EncodedData()) else { return }
            issuedDeviceData = self.decodingIssuedDeviceData(jsondata: data)
            if issuedDeviceData.isEmpty {
                completionHandler(nil)
            } else {
                completionHandler(issuedDeviceData)
            }
        })
    }
    
    func takeSnapshotOfEmployeeDetails(completionHandler : @escaping ([Employee]?) -> ()) {
        ref.child("EmployeeTable").observeSingleEvent(of: .value, with: { (snapshot) in
            var employeeDetails : [Employee] = []
            guard let value = snapshot.value else { return }
            guard let model = try? JSONSerialization.data(withJSONObject: value) else { return }
           
            guard let data = Data(base64Encoded: model.base64EncodedData()) else { return }
            employeeDetails = self.decodingEmployeeData(jsondata: data)
            if employeeDetails.isEmpty {
                completionHandler(nil)
            } else {
                completionHandler(employeeDetails)
            }
        })
    }
    
    func takeSnapshotForDeviceHistory(of deviceId : String,fromDate: TimeInterval, toDate: TimeInterval, fetchingAgain : Bool, completionHandler : @escaping ([IssuedDevices]?) -> ()) {
        if fetchingAgain == false {
             ref.child("IssuedDeviceTable")
                .queryOrdered(byChild: "deviceID")
                .queryEqual(toValue: deviceId)
                .queryLimited(toFirst: 10)
                .observeSingleEvent(of: .value, with: { snapshot in
                
                    var issuedDeviceData : [IssuedDevices] = []

                    guard let value = snapshot.value else { return }
                    guard let model = try? JSONSerialization.data(withJSONObject: value) else { return }
                    guard let data = Data(base64Encoded: model.base64EncodedData()) else { return }

                    issuedDeviceData = self.decodingIssuedDeviceData(jsondata: data)
                    if issuedDeviceData.isEmpty {
                        completionHandler(nil)
                    } else {
                        completionHandler(issuedDeviceData)
                    }
                })
        }
        else if fetchingAgain == true {
            guard let lastKey = keys.last else { return }
       
            ref.child("IssuedDeviceTable")
                .queryOrdered(byChild:"deviceID")
                .queryStarting(atValue: deviceId, childKey: lastKey)
                .queryEnding(atValue: deviceId)
                .queryLimited(toFirst: 10)
                .observeSingleEvent(of: .value, with: { snapshot in
                    
                    var issuedDeviceData : [IssuedDevices] = []

                    guard let value = snapshot.value else { return }
                    guard let model = try? JSONSerialization.data(withJSONObject: value) else { return }
                    guard let data = Data(base64Encoded: model.base64EncodedData()) else { return }
                    issuedDeviceData = self.decodingIssuedDeviceData(jsondata: data)
                    if issuedDeviceData.isEmpty {
                        completionHandler(nil)
                    } else {
                        completionHandler(issuedDeviceData)
                    }
                })
        }
    }
    
    
    func addNewDevice(deviceID : String, modelName : String, platform : String, osVersion : String) {
        ref.child("DeviceTable").child(deviceID).setValue(["deviceID" : deviceID,"modelName" : modelName,"platform" : platform,"oSVersion" : osVersion, "status" : "Available"]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func updateDatabase(with id: String, modelName : String, platform : String, osVersion : String, status : String) {
        ref.child("DeviceTable/\(id)").setValue(["deviceID" : id,"modelName" : modelName,"platform" : platform,"oSVersion" : osVersion, "status" : status]) {
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
    
    func deleteFromIssuedTable(with childId : String) {
        let removingID = ref.child("IssuedDeviceTable").child(childId)
        removingID.removeValue()
    }
    
    
    func addNewCheckIn(childID : String,cueID : String,name : String, deviceID : String, date : Date, checkin : String) {
        
        let timestamp =  Date().timeIntervalSince1970
        
        ref.child("IssuedDeviceTable").child(childID).setValue(["cueID" : cueID,"name" : name, "deviceID" : deviceID, "date" : timestamp, "checkin" : checkin, "checkout" : "-- : --", "status" : "Issued"]) { (error:Error?,ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func addCheckOut(childID : String, cueID : String, name : String, deviceID : String, date : TimeInterval, checkin : String, checkout : String) {
        ref.child("IssuedDeviceTable").child(childID).setValue(["cueID" : cueID,"name" : name, "deviceID" : deviceID, "date" : date, "checkin" : checkin, "checkout" : checkout, "status" : "Available"]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                self.successful = false
            } else {
                self.successful = true
            }
        }
    }
    
    func createNewUser(cueID : String, email : String, username : String, completionHandler : @escaping (Bool)-> ()) {
        ref.child("EmployeeTable").child(cueID).setValue(["cueID" : cueID, "email" : email, "username" : username]) {
            (error:Error?, ref:DatabaseReference) in
            if error != nil {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
    
    func updateDeviceStatusAfterCheckin(of deviceID: String) {
        ref.child("DeviceTable").child(deviceID).child("status").setValue("Issued")
    }
    
    func updateDeviceStatusAfterCheckout(of deviceID: String) {
        ref.child("DeviceTable").child(deviceID).child("status").setValue("Available")
    }
    
}
