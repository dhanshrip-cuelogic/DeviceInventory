//
//  IssuedDevices.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 06/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

@objcMembers class IssuedDevices : NSObject, Codable {
    var cueID : String
    var name : String
    var deviceID : String
    var date : TimeInterval
    var checkin : String
    var checkout : String
    var status : String
}
