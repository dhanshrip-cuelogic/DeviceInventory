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
    var issuedDevices : [IssuedDevices] {get set}
    var lastKey : String {get set}
    func reloadTable()
}

class DeviceHistoryPresenter {
    
    var deviceHistoryDelegate : DeviceHistoryProtocol?
    var sortedData : [IssuedDevices] = []
    
    func sortByDeviceID(id : String, fromDate : TimeInterval, toDate : TimeInterval, fetch : Bool){
        DatabaseManager.shared.takeSnapshotForDeviceHistory(of: id, fromDate : fromDate, toDate: toDate, fetchingAgain: fetch, completionHandler: { (issuedData) in
            
            //            let from = Date(timeIntervalSince1970: fromDate) as NSDate
            //            let to = Date(timeIntervalSince1970: toDate) as NSDate
            //            var myarray : [IssuedDevices] = []
            //            for device in issuedData! {
            //                myarray.append(device)
            //            }
            //            let fromPredicate = NSPredicate(format: "self.Date >= %@", fromDate)
            //            let toPredicate = NSPredicate(format: "self.Date < %@", toDate)
            //            let predicateRule = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate , toPredicate])
            //            let filteredData = myarray.filter { predicateRule.evaluate(with: $0) }
            //
            //            self.sortedData = (filteredData as NSArray).sortedArray(using: [NSSortDescriptor(key: "Date", ascending: true)]) as! [IssuedDevices]
            
            for device in issuedData! {
                self.deviceHistoryDelegate?.issuedDevices.append(device)
            }
            self.deviceHistoryDelegate?.reloadTable()
        })
    }
    
}
