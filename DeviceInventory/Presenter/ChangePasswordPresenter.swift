//
//  ChangePasswordPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 29/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import Firebase

protocol ChangePasswordProtocol {
    var errorTextFieldFromChangePasswordPage : UILabel? {get set}
    var storyBoardFromChangePasswordPage : UIStoryboard? {get set}
    var viewFromChangePasswordPage : UIView? {get set}
    func showAlert()
}

class ChangePasswordPresenter {
    
    var changePasswordDelegate : ChangePasswordProtocol?
    var newPasswordFromChangePasswordPage : String?
    
    // When Change Password Button is clicked it will validate the password.
    // If it is filled correctly then it will update old password with new password.
    func whenChangePasswordButtonPressed() {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        }else {
            // Take cleaned data from text fields
            let newPassword = newPasswordFromChangePasswordPage?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Update password with new password and redirect to Platform Selection Page.
            Auth.auth().currentUser?.updatePassword(to: newPassword!, completion: { (error) in
                if error != nil {
                    self.showError("Error in changing password.")
                }
                else {
                    self.changePasswordDelegate?.showAlert()
                    self.redirectToPlatformSelectionPage()
                }
            })
        }
    }
    
    // Redirect to platform selection page using storyboardID.
    func redirectToPlatformSelectionPage() {
        let platformSelectionPage = changePasswordDelegate?.storyBoardFromChangePasswordPage?.instantiateViewController(identifier: "PlatformSelectionPage")
        changePasswordDelegate?.viewFromChangePasswordPage?.window?.rootViewController = platformSelectionPage
    }
    
    // Validate new password with regular expression.
    func validateNewPassword() -> Bool? {
        let passwordRegEx = "^([A-Z]+)([a-z]?.*)([!@#$%^&*.].*)([0-9].*)$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let newPasswordResult = passwordTest.evaluate(with: newPasswordFromChangePasswordPage!)
        return newPasswordResult
    }
    
    // Validate whether the field is empty or not.
    func validateFields() -> String? {
        let newPasswordValidate = validateNewPassword()
     
        if newPasswordFromChangePasswordPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please enter password."
        }
        else if newPasswordValidate == false {
            return "Please enter valid new password."
        }
        return nil
    }
    
    // Display error on screen.
    func showError(_ message : String) {
         changePasswordDelegate?.errorTextFieldFromChangePasswordPage!.text = message
         changePasswordDelegate?.errorTextFieldFromChangePasswordPage!.alpha = 1
     }
}

