//
//  User.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
/*
 This is used to show functionality according to the user.
 If the user is Admin then he can perform CRUD Operations on devices.
 If the user is Employee then he can only see details and issue device.
 */
enum User : String {
    case admin = "admin"
    case employee = "employee"
}

