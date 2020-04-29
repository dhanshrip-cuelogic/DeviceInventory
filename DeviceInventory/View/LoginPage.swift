//
//  LoginPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 27/04/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit
import Firebase

class LoginPage: UIViewController , LoginPageProtocol {
    
    var errorTextFieldOfLoginPage : UILabel?
    
    var user : String?
    
    let loginPresenter = LoginPresenter()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorTextField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorTextField.alpha = 0
        
        loginButton.layer.cornerRadius = 20.0
        
        loginPresenter.loginDelegate = self
        
    }
    
    @IBAction func redirectToSignUpButtonClicked(_ sender: UIButton) {
//            loginPresenter.transitionToSignUp()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        loginPresenter.emailTextFromLoginPage = emailTextField.text!
        loginPresenter.passwordTextFromLoginPage = passwordTextField.text!
        errorTextFieldOfLoginPage = errorTextField
        loginPresenter.whenLoginButtonIsClicked()
    }
    
    }
