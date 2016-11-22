//
//  PasswordChangeViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PasswordChangeViewController: UIViewController {

    @IBOutlet weak var currentPasswordTextfield: UITextField!
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordConfirmationTextField: UITextField!
    @IBOutlet weak var saveButton: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = customLightGray
        
        self.currentPasswordTextfield.isSecureTextEntry = true
        self.newPasswordTextField.isSecureTextEntry = true
        self.newPasswordConfirmationTextField.isSecureTextEntry = true
        
        self.currentPasswordTextfield.backgroundColor = .white
        self.newPasswordTextField.backgroundColor = .white
        self.newPasswordConfirmationTextField.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.currentPasswordLabel.text = "CURRENT_PASSWORD".localized
        self.newPasswordLabel.text = "NEW_PASSWORD".localized
        self.currentPasswordTextfield.placeholder = "CURRENT_PASSWORD_PH".localized
        self.newPasswordTextField.placeholder = "NEW_PASSWORD_PH".localized
        self.newPasswordConfirmationTextField.placeholder = "NEW_PASSWORD_CONFIRMATION_PH".localized
            
        self.saveButton.setTitle("SAVE".localized, for: .normal)
        self.saveButton.setTitle("SAVE".localized, for: .selected)
    }

    
    @IBAction func handleSaveButtonTapped(_ sender: AnyObject) {
        
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
