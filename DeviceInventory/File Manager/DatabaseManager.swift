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
    private (set) var fetchedData : [DeviceDetails]? {
        didSet {
             NotificationCenter.default.post(name: Notification.Name(rawValue: "loadedPost"), object: nil)
        }
    }
    
    private init() {
           //
       }
    
     func createReference(){
        ref = Database.database().reference()
        ref.child("DeviceTable").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else { return }
            let model = try? JSONSerialization.data(withJSONObject: value)
            
            guard let data = Data(base64Encoded: model!.base64EncodedData()) else { return }
            self.fetchedData = self.decoding(jsondata: data)
        })
     }
    
     func decoding(jsondata : Data?) -> [DeviceDetails]{
        let data = try! decoder.decode([String : DeviceDetails].self, from: jsondata!)
        for device in data{
            deviceData.append(device.value)
        }
        return deviceData
     }
}
