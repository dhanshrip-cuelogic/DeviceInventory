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
        errorTextField.alpha = 0
        signUpButton.layer.cornerRadius = 20.0
        
        signUpPresenter.signUpDelegate = self as SignUpProtocol
        
    }
    
    @IBAction func redirectToLoginButtonClicked(_ sender: UIButton) {
        signUpPresenter.performTransition()
    }

    @IBAction func SignUpButtonClicked(_ sender: UIButton) {
        signUpPresenter.signUpEmailFromSignUpPage = signUpEmailTextField.text!
        signUpPresenter.signUpPasswordFromSignUpPage = signUpPasswordTextField.text!
        signUpPresenter.signUpCueIDFromSignUpPage = signUpCueIdTextField.text!
        errorTextFieldOfSignUpPage = errorTextField
        storyboardFromSignUpPage = storyboard
        viewFromSignUpPage = view
        signUpPresenter.whenSignUpButtonClicked()
    }    
}
