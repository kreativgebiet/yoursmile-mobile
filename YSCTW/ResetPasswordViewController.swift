//
//  ResetPasswordViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 05.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: LeftViewImageTextField!
    @IBOutlet weak var resetPasswordButton: RoundedButton!
    @IBOutlet weak var gotoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.resetPasswordButton.backgroundColor = blue
        
        self.resetPasswordButton.setTitle("RESET_PASSWORD".localized, for: .normal)
        self.resetPasswordButton.setTitle("RESET_PASSWORD".localized, for: .selected)
        
        self.emailTextField.placeholder = "EMAIL".localized
        
        self.emailTextField.leftViewImage = #imageLiteral(resourceName: "mail-icon")
        self.emailTextField.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight).union(UIRectCorner.bottomLeft).union(UIRectCorner.bottomRight)
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.text = ""
        self.emailTextField.delegate = self
        
        let text1 = "ACCOUNT_LABEL".localized + " "
        let text2 = "LOGIN_BUTTON".localized
        let mutableString = NSMutableAttributedString(
            string: text1+text2)
        
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: customDarkGray, range: NSMakeRange(0, text1.characters.count))
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: orange, range: NSMakeRange(text1.characters.count, text2.characters.count))
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .normal)
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .selected)
        self.gotoLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        self.view.endEditing(true)
    }
    
    @IBAction func handleGotoLoginButtonTapped(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func handleResetPasswordButtonTapped(_ sender: AnyObject) {
        
        let email = self.emailTextField.text
        self.view.endEditing(true)
        
        var errorMessage = ""
        
        if !(email?.isValidEmail)! {
            errorMessage = errorMessage + "MAIL_ERROR".localized + " "
        }
        
        if errorMessage.characters.count > 0 {
            HelperFunctions.presentAlertViewfor(error: errorMessage)
            return
        }
        
        let loadingScreen = LoadingScreen(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        APIClient.resetPasswordFor(email: email) { (success, errorString) in
            loadingScreen.removeFromSuperview()
            
            if success {
                HelperFunctions.presentAlertViewfor(error: "PASSWORD_RESET_SUCCESS".localized)
            } else {
                HelperFunctions.presentAlertViewfor(error: errorString)
            }
            
        }
    }
    
    // MARK: - TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
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
