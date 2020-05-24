//
//  ChangePassword.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 29/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class ChangePassword: CustomNavigationController, ChangePasswordProtocol {
    
    var errorTextFieldFromChangePasswordPage: UILabel?
    
    let changePasswordPresenter = ChangePasswordPresenter()
    
    @IBOutlet weak var circularImage: UIImageView!
    @IBOutlet weak var changePasswordNewPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Change Password Page as delegate to its Presenter.
        changePasswordPresenter.changePasswordDelegate = self
        prepareForLoading()
    }
    
    func prepareForLoading() {
       self.navigationItem.hidesBackButton = true
       navigationItem.title = "Change Password"
       navigationItem.leftBarButtonItem = backButton()
       circularImage.layer.masksToBounds = true
       circularImage.layer.cornerRadius = circularImage.bounds.width / 2
       changePasswordButton.layer.cornerRadius = 5.0
       changePasswordNewPasswordTextField.addBottomBorder()
       errorLabel.alpha = 0
    }
    
    // When Change Password button is pressed, the value is sent to presenter for validation updation.
    @IBAction func confirmChangingPasswordButton(_ sender: UIButton) {
        errorTextFieldFromChangePasswordPage = errorLabel
        changePasswordPresenter.newPasswordFromChangePasswordPage = changePasswordNewPasswordTextField.text!
        changePasswordPresenter.whenChangePasswordButtonPressed()
    }
    
    // This function will show an alert on successfull updation of password.
    func showAlert() {
        let alert = UIAlertController(title: "Successfull", message: "Password changed Succesfully", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (saveAction) in
            self.redirect()
        }
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    
    func redirect() {
        let platformSelectionPage = self.storyboard!.instantiateViewController(withIdentifier: "PlatformSelectionPage") as! PlatformSelectionPage
        self.navigationController?.pushViewController(platformSelectionPage, animated: false)
    }
}
