//
//  PasswordChangeViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    @IBOutlet weak var saveButton: RoundedButton!
    
    public var dataManager: DataManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = customLightGray
        self.newPasswordLabel.textColor = customMiddleGray
        
        self.newPasswordTextField.isSecureTextEntry = true
        self.newPasswordConfirmationTextField.isSecureTextEntry = true
        
        self.newPasswordTextField.backgroundColor = .white
        self.newPasswordConfirmationTextField.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.newPasswordLabel.text = "NEW_PASSWORD".localized
        self.newPasswordTextField.placeholder = "NEW_PASSWORD_PH".localized
        self.newPasswordConfirmationTextField.placeholder = "NEW_PASSWORD_CONFIRMATION_PH".localized
            
        self.saveButton.setTitle("SAVE".localized, for: .normal)
        self.saveButton.setTitle("SAVE".localized, for: .selected)
    }

    
    @IBAction func handleSaveButtonTapped(_ sender: AnyObject) {
        
        let password = self.newPasswordTextField.text
        let passwordConfirm = self.newPasswordConfirmationTextField.text
        
        var errorMessage = ""
        
        if password != passwordConfirm {
            errorMessage = "PASSWORD_CONFIRM_ERROR".localized
        }
        
        if (password?.characters.count)! < 8 {
            errorMessage = (errorMessage.characters.count > 0 ? errorMessage + " " : errorMessage)
            errorMessage = errorMessage + "PASSWORD_ERROR".localized
        }
        
        if errorMessage.characters.count > 0 {
            HelperFunctions.presentAlertViewfor(error: errorMessage)
            return
        }
        
        let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        
        self.view.endEditing(true)
        self.view.addSubview(loadingScreen)
        
        let callback = { (success: Bool, errorMessage: String) in
            
            loadingScreen.removeFromSuperview()
            
            if success {
                HelperFunctions.presentAlertViewfor(information: "PASSWORD_CHANGED".localized, presenter: self)
            } else {
                HelperFunctions.presentAlertViewfor(error: errorMessage)
            }
            
        }
        
        self.dataManager.resetPassword(password: password!, callback:  callback)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
