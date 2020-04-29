//
//  SignUpPresenter.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 29/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol SignUpProtocol {
    var errorTextFieldOfSignUpPage : UILabel? { get set }
    var storyboardFromSignUpPage : UIStoryboard? {get set}
    var viewFromSignUpPage : UIView? {get set}
}

class SignUpPresenter {
    
    var signUpDelegate : SignUpProtocol?
    
    var signUpEmailFromSignUpPage : String?
    var signUpPasswordFromSignUpPage : String?
    var signUpCueIDFromSignUpPage : String?
    
    func whenSignUpButtonClicked() {
        //validate fields
        let error = validateFields()
        
        //if error while validating fields
        if error != nil {
            showError(error!)
        }else {
            //cleaned data after validation
            let email = signUpEmailFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = signUpPasswordFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines)
            let cueid = signUpCueIDFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create user
            Auth.auth().createUser(withEmail: email!, password: password!) { (result, err) in
                if err != nil {
                    self.showError("Error while creating user.")
                }else {
                     //save CueID
                    let db = Firestore.firestore()
                    
                    db.collection("Employee").addDocument(data: ["CueID" : cueid! , "uid" : result!.user.uid]) { (error) in
                        if error != nil {
                            self.showError("Could not be able to save CueID")
                        }
                    }
                     //transition to next page
                    print("sign up successfull !!!!!")
                    self.performTransition()
                }
            }
        }
    }
    
    func validateFields() -> String? {
        let passwordValidate = validatePassword()
        let emailValidate = validateEmail()
        let cueIdValidate = validateCueID()
        if signUpEmailFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || signUpPasswordFromSignUpPage?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields."
        }
        else if passwordValidate == false {
            return "Please enter valid password."
        }
        else if emailValidate == false{
            return "Please enter valid email."
        }
        else if cueIdValidate == false {
            return "Please enter valid CueId."
        }
        return nil
    }
    
    func showError(_ message : String) {
        signUpDelegate?.errorTextFieldOfSignUpPage!.text = message
        signUpDelegate?.errorTextFieldOfSignUpPage!.alpha = 1
    }
    
    func performTransition() {
        let loginpage = signUpDelegate?.storyboardFromSignUpPage!.instantiateViewController(identifier: "Loginpage") as! LoginPage
            signUpDelegate?.viewFromSignUpPage!.window?.rootViewController = loginpage
    }
    
    func validatePassword() -> Bool? {
        let passwordRegEx = "^([A-Z]+)([a-z]?.*)([!@#$%^&*.].*)([0-9].*)$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let passwordResult = passwordTest.evaluate(with: signUpPasswordFromSignUpPage!)
        return passwordResult
    }
    
    func validateEmail() -> Bool? {
        let emailRegEx = "^([a-z]+)([.]{1})([a-z]+)(@cuelogic.com)$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailResult = emailTest.evaluate(with: signUpEmailFromSignUpPage!)
        return emailResult
    }
    
    func validateCueID() -> Bool? {
        let cueIdRegEx = "^(Cue)([0-9]{5})$"
        let cueIdTest = NSPredicate(format:"SELF MATCHES %@", cueIdRegEx)
        let cueIdResult = cueIdTest.evaluate(with: signUpCueIDFromSignUpPage!)
        return cueIdResult
    }
}
