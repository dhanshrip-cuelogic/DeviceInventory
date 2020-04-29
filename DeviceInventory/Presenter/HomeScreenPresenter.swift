//
//  HomeScreenPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation

protocol HomeScreenProtocol {
//    var user : User? { get set }
    func performSegue()
}

class HomeScreenPresenter {
    
    var homeScreenDelegate : HomeScreenProtocol?
    var user : User?

    
    func whenAdminButtonIsClicked() {
        user = .admin
        homeScreenDelegate?.performSegue()
    }
    
    func whenEmployeeButtonIsClicked() {
        user = .employee
        homeScreenDelegate?.performSegue()
    }

    
}

