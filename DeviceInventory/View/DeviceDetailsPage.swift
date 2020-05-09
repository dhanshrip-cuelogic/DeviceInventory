//
//  DeviceDetailsPage.swift
//  DeviceInventory
//
//  Created by Dhanshri Pawar on 04/05/20.
//  Copyright © 2020 Dhanshri Pawar. All rights reserved.
//

import UIKit

class DeviceDetailsPage: UIViewController, DeviceDetailsProtocol {
    
    @IBOutlet weak var DeviceIDTextField: UITextField!
    @IBOutlet weak var ModelNameTextField: UITextField!
    @IBOutlet weak var PlatformTextField: UITextField!
    @IBOutlet weak var OSVersionTextfield: UITextField!
    @IBOutlet weak var ErrorLabel: UILabel!
    var errorLabel : UILabel?
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
        ErrorLabel.alpha = 0
        
        // if the opeartion is to perform edit then fields will get auto populated with the details of that device.
        DeviceIDTextField.text = deviceID
        ModelNameTextField.text = modelName
        PlatformTextField.text = platform
        OSVersionTextfield.text = osVersion
    }
    
    //This will call saveButtonClicked method from presenter to add new device data into database.
    @IBAction func SaveButton(_ sender: UIButton) {
        deviceDetailPresenter.deviceID = DeviceIDTextField.text!
        deviceDetailPresenter.modelName = ModelNameTextField.text!
        deviceDetailPresenter.platform = PlatformTextField.text!
        deviceDetailPresenter.osVersion = OSVersionTextfield.text!
        deviceDetailPresenter.status = status
        errorLabel = ErrorLabel
        deviceDetailPresenter.performEditing = performEditing
    
        deviceDetailPresenter.saveButtonClicked()
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
