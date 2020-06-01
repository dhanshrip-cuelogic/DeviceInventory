//
//  ResetPassword.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class ResetPassword : CustomNavigationController{
    
    @IBOutlet weak var emailTextField: UITextField!
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        self.navigationItem.hidesBackButton = true
        navigationItem.title = "Login"
        navigationItem.leftBarButtonItem = backButton()
//        emailTextField.addBottomBorder()
    }
    
    @IBAction func resetPasswordButton(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        DatabaseManager.shared.resetPassword(email: email) {
            successful, error in
            if successful == true {
                self.showAlert(title: "Done", message: "Password reset email has been sent. Please checck the mail and follow the instructions.")
                
            } else {
                self.emailTextField.text = ""
                self.showErrorAlert(title: "Failed", message: "Failed to send mail. Please try again.")
            }
        }
    }
    
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           let loginpage = self.storyboard!.instantiateViewController(withIdentifier: "Loginpage") as! LoginPage
            loginpage.user = self.user
           self.navigationController?.pushViewController(loginpage, animated: false)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let FailAction = UIAlertAction(title: "OK", style: .default) { (action) in
    
        }
        alert.addAction(FailAction)
        present(alert, animated: true, completion: nil)
    }
}
