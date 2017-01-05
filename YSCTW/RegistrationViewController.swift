//
//  RegistrationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: LeftViewImageTextField!
    @IBOutlet weak var mailTextField: LeftViewImageTextField!
    @IBOutlet weak var passwordTextField: LeftViewImageTextField!
    
    @IBOutlet weak var registerButton: RoundedButton!
    @IBOutlet weak var logoTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTextFieldTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var logoTitleLabel: UILabel!
    @IBOutlet weak var gotoLoginButton: UIButton!
    
    var defaultLogoTopSpaceConstraintConstant: CGFloat?
    var defaultnameTextFieldTopSpaceConstraintConstant: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if screenSize.height <= 568  {
            self.nameTextFieldTopSpaceConstraint.constant = 80
        }
        
        self.defaultLogoTopSpaceConstraintConstant = self.logoTopSpaceConstraint.constant
        self.defaultnameTextFieldTopSpaceConstraintConstant = self.nameTextFieldTopSpaceConstraint.constant
        
        self.mailTextField.leftViewImage = UIImage(named: "mail-icon")!
        self.mailTextField.autocorrectionType = .no
        self.mailTextField.delegate = self
        
        self.nameTextField.leftViewImage = UIImage(named: "user-icon")!
        self.nameTextField.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight)
        self.nameTextField.autocorrectionType = .no
        self.nameTextField.delegate = self
        
        self.passwordTextField.leftViewImage = UIImage(named: "password-icon")!
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight)
        self.passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGesture)
        
        self.applyLocalization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.applyLocalization()
    }
    
    func applyLocalization() {
        //Localization
        self.registerButton.setTitle("LOGIN".localized, for: .normal)
        self.registerButton.setTitle("LOGIN".localized, for: .selected)
        
        self.mailTextField.placeholder = "EMAIL".localized
        self.passwordTextField.placeholder = "PASSWORD".localized
        
        let text1 = "ACCOUNT_LABEL".localized + " "
        let text2 = "LOGIN_BUTTON".localized
        let mutableString = NSMutableAttributedString(
            string: text1+text2)
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: customDarkGray, range: NSMakeRange(0, text1.characters.count))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: orange, range: NSMakeRange(text1.characters.count, text2.characters.count))
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .normal)
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .selected)
        self.gotoLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.nameTextField {
            self.mailTextField.becomeFirstResponder()
        } else if textField == self.mailTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.setNeedsLayout()
        textField.layoutIfNeeded()
    }
    
    // MARK: - Button Action
    
    func backgroundTap() {
        self.view.endEditing(true)
    }

    @IBAction func handleLoginButtonTapped(_ sender: AnyObject) {        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func handleRegisterButtonTapped(_ sender: AnyObject) {
        
        let mail = self.mailTextField.text
        let password = self.passwordTextField.text
        let name = self.nameTextField.text
        
        var errorMessage = ""
        
        if name?.characters.count == 0 {
            errorMessage = "NAME_ERROR".localized + " "
        }
        
        if !(mail?.isValidEmail)! {
            errorMessage = errorMessage + "MAIL_ERROR".localized + " "
        }
        
        if (password?.characters.count)! < 8 {
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
            
            if success {
                DataManager().login(email: mail!, password: password!, { (success) in
                    loadingScreen.removeFromSuperview()
                    if success {
                        self.performSegue(withIdentifier: "registrationNavigationControllerSegue", sender: self)
                    }
                })
            } else {
                loadingScreen.removeFromSuperview()
                HelperFunctions.presentAlertViewfor(error: errorMessage)
            }
            
        }
        
        APIClient.registerUser(name: name!, email: mail!, password: password!, callback: callback)
    }
        
    // MARK: - Keyboard animations
    
    func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        var topSpace:CGFloat = 54
        var nameTextFieldTopSpace:CGFloat = 40
        
        if screenSize.height <= 568  {
            topSpace = 0
            nameTextFieldTopSpace = 30
        }
        
        self.logoTopSpaceConstraint.constant = moveUp ? topSpace : self.defaultLogoTopSpaceConstraintConstant!
        let alpha = moveUp ? 0 : 1 as CGFloat
        self.nameTextFieldTopSpaceConstraint.constant = moveUp ? nameTextFieldTopSpace : self.defaultnameTextFieldTopSpaceConstraintConstant!
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options,
                                   animations: {
                                    self.view.layoutIfNeeded()
                                    self.logoTitleLabel.alpha = alpha
            },
                                   completion: nil
        )
    }
    
}
