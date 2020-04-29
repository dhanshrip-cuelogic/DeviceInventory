//
//  SignUpPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 28/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpPage: UIViewController, SignUpProtocol {
    
    var storyboardFromSignUpPage: UIStoryboard?
    var viewFromSignUpPage: UIView?
    var errorTextFieldOfSignUpPage: UILabel?
    
    let signUpPresenter = SignUpPresenter()

    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpCueIdTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        To set this SignUp page as delegate to its Presenter and set storyboard and view for transition purpose.
        errorTextField.alpha = 0
        signUpButton.layer.cornerRadius = 20.0
        signUpPresenter.signUpDelegate = self as SignUpProtocol
        storyboardFromSignUpPage = storyboard
        viewFromSignUpPage = view
        
    }
    
//    For redirection to Login Page on successfull signUp of new user.
    @IBAction func redirectToLoginButtonClicked(_ sender: UIButton) {
        signUpPresenter.performTransition()
    }

//    When signUp button is clicked it will send the data from textfields to the presenter for validation and creation of new user.
    @IBAction func SignUpButtonClicked(_ sender: UIButton) {
        signUpPresenter.signUpEmailFromSignUpPage = signUpEmailTextField.text!
        signUpPresenter.signUpPasswordFromSignUpPage = signUpPasswordTextField.text!
        signUpPresenter.signUpCueIDFromSignUpPage = signUpCueIdTextField.text!
        errorTextFieldOfSignUpPage = errorTextField
        signUpPresenter.whenSignUpButtonClicked()
    }    
}
