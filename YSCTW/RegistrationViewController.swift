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

class RegistrationViewController: UIViewController {

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
        
        self.defaultLogoTopSpaceConstraintConstant = self.logoTopSpaceConstraint.constant
        self.defaultnameTextFieldTopSpaceConstraintConstant = self.nameTextFieldTopSpaceConstraint.constant
        
        self.mailTextField.leftViewImage = UIImage(named: "mail-icon")!
        self.mailTextField.autocorrectionType = .no
        
        self.nameTextField.leftViewImage = UIImage(named: "user-icon")!
        self.nameTextField.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight)
        self.nameTextField.autocorrectionType = .no
        
        self.passwordTextField.leftViewImage = UIImage(named: "password-icon")!
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight)
        
        //Localization
        self.registerButton.setTitle("LOGIN".localized, for: .normal)
        self.registerButton.setTitle("LOGIN".localized, for: .selected)
        
        self.registerButton.setTitle("REGISTER_BUTTON".localized, for: .normal)
        self.registerButton.setTitle("REGISTER_BUTTON".localized, for: .selected)
        self.mailTextField.placeholder = "EMAIL".localized
        self.passwordTextField.placeholder = "PASSWORD".localized
        
        let text1 = "ACCOUNT_LABEL".localized
        let text2 = "LOGIN_BUTTON".localized
        let mutableString = NSMutableAttributedString(
            string: text1+text2,
            attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)])
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: customDarkGray, range: NSMakeRange(0, text1.characters.count))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: orange, range: NSMakeRange(text1.characters.count, text2.characters.count))
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .normal)
        self.gotoLoginButton.setAttributedTitle(mutableString, for: .selected)
        self.gotoLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
            let alert = UIAlertView()
            alert.title = "ERROR".localized
            alert.message = String(describing: errorMessage)
            alert.addButton(withTitle: "OK")
            alert.show()
            
            return
        }
        
        let sign_up = "auth/"
        let requestURL = baseURL + sign_up
        
        let parameters: [String : String] = [
            "nickname": name!,
            "email": mail!,
            "password": password!,
            "name": name!            
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            print(response.result.value)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                let alert = UIAlertView()
                alert.title = "An error occured"
                alert.message = String(describing: json["errors"])
                alert.addButton(withTitle: "OK")
                alert.show()
                
                break
            case .failure(let error):
                
                print(error)
            }
            
        }

    }
        
    // MARK: - Keyboard animations
    
    func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        var topSpace:CGFloat = 54
        
        if screenSize.height <= 568  {
            topSpace = 0
        }
        
        self.logoTopSpaceConstraint.constant = moveUp ? topSpace : self.defaultLogoTopSpaceConstraintConstant!
        let alpha = moveUp ? 0 : 1 as CGFloat
        self.nameTextFieldTopSpaceConstraint.constant = moveUp ? 20 : self.defaultnameTextFieldTopSpaceConstraintConstant!
        
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
