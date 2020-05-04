//
//  HomeScreenPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol HomeScreenProtocol {
    var user : User? { get set }
    func performSegue()
}

class HomeScreenPresenter {
    
    var homeScreenDelegate : HomeScreenProtocol?
//    var user : User?

//     When user is selected it will send the user value to further viewcontrollers to show relevent data accordingly.
    func whenAdminButtonIsClicked() {
        homeScreenDelegate?.user = .admin
        homeScreenDelegate?.performSegue()
    }
    
    func whenEmployeeButtonIsClicked() {
        homeScreenDelegate?.user = .employee
        homeScreenDelegate?.performSegue()
    }
}

