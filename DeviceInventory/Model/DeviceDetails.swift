//
//  DeviceDetails.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 02/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

struct DeviceDetails : Codable{
    var DeviceID : String?
    var ModelName : String
    var Platform : String
    var OSVersion : String
    var RAM : String?
    var Display : String?
    var Status : String
}
