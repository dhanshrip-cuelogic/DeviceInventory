//
//  DeviceDetailsPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceDetailsPage: CustomNavigationController, DeviceDetailsProtocol {
    
    @IBOutlet weak var deviceIDTextField: UITextField!
    @IBOutlet weak var modelNameTextField: UITextField!
    @IBOutlet weak var platformTextField: UITextField!
    @IBOutlet weak var oSVersionTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var currentDeviceButton: UIButton!
    
    var errorText : UILabel?
    var performEditing : Bool?
    
    // Data recieved from Device List Page
    var deviceID : String?
    var modelName : String?
    var platform : String?
    var osVersion : String?
    var status : String?
    
    let deviceDetailPresenter = DeviceDetailsPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceDetailPresenter.deviceDetailDelegate = self
        initUI()
    }
    
    func initUI() {
        navigationItem.title = "Device Details"
        errorLabel.alpha = 0
        saveButton.layer.cornerRadius = 5.0
        deviceIDTextField.addBottomBorder()
        modelNameTextField.addBottomBorder()
        platformTextField.addBottomBorder()
        oSVersionTextfield.addBottomBorder()
        
        // This button works temporarily for adding iOS devices only, otherwise it will be hidden.
        if platform != "iOS" {
            currentDeviceButton.isHidden = true
        }
        
        self.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton()
        
        // if the opeartion is to perform edit then fields will get auto populated with the details of that device.
        if performEditing == true {
            deviceIDTextField.text = deviceID
            modelNameTextField.text = modelName
            platformTextField.text = platform
            oSVersionTextfield.text = osVersion
        }
    }
    
    //This will call saveButtonClicked method from presenter to add new device data into database.
    @IBAction func SaveButton(_ sender: UIButton) {
        deviceDetailPresenter.deviceID = deviceIDTextField.text!
        deviceDetailPresenter.modelName = modelNameTextField.text!
        deviceDetailPresenter.platform = platformTextField.text!
        deviceDetailPresenter.osVersion = oSVersionTextfield.text!
        deviceDetailPresenter.status = status
        errorText = errorLabel
        deviceDetailPresenter.performEditing = performEditing
        
        deviceDetailPresenter.saveButtonClicked()
    }
    
    @IBAction func addCurrrentDevice(_ sender: UIButton) {
        guard let platform = platform else { return }
        if platform == "iOS" {
            oSVersionTextfield.text = deviceDetailPresenter.getOSversion()
            modelNameTextField.text = deviceDetailPresenter.getModelName()
            platformTextField.text = "iOS"
        } else {
            // If platform is android then call function to fetch details from android device.
        }
    }
    
    
    // This will show an alert after successfully saving data into database.
    func showAlert() {
        let alert = UIAlertController(title: "Successfull", message: "Saved data Succesfully", preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .default) { (saveAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OkAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
}
