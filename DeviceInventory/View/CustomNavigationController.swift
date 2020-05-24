//
//  CustomNavigationController.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 12/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class CustomNavigationController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 15)!]
    }
    
    func backToHomeScreen() -> UIBarButtonItem{
        let barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToHome))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 12)!], for: .normal)
        return barButton
    }
    
    func backButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popViewController))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 12)!], for: .normal)
        return barButton
    }
    
    func logoutButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 12)!], for: .normal)
        return barButton
    }
    
    func changePassword() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Change Password", style: .plain, target: self, action: #selector(redirectToChangePassword))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 12)!], for: .normal)
        return barButton
    }
    
    func addButton(selector : Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: selector)
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 12)!], for: .normal)
        return barButton
    }
    
}

extension CustomNavigationController {
    
    @objc func logout() {
        let def = UserDefaults.standard
        def.set(false, forKey: "is_authenticated") // save false flag to UserDefaults
        def.synchronize()
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @objc func redirectToChangePassword() {
        let changePasswordPage = self.storyboard!.instantiateViewController(withIdentifier: "changePasswordPage") as! ChangePassword
        self.navigationController?.pushViewController(changePasswordPage, animated: false)
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func backToHome() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
}
