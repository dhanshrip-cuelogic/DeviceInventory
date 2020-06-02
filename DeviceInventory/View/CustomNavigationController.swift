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
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 13)!], for: .normal)
        return barButton
    }
    
    func backButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(popViewController))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 13)!], for: .normal)
        return barButton
    }
    
    func logoutButton() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 13)!], for: .normal)
        return barButton
    }
    
    func changePassword() -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Edit Password", style: .plain, target: self, action: #selector(redirectToChangePassword))
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 13)!], for: .normal)
        return barButton
    }
    
    func addButton(selector : Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: selector)
        barButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "OpenSans", size: 13)!], for: .normal)
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

var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension UITextField {
    func addBottomBorder() {
        self.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

