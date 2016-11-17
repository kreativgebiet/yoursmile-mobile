//
//  LoginViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: LeftViewImageTextField!
    @IBOutlet weak var passwordTextField: LeftViewImageTextField!
    @IBOutlet weak var logoTitleLabel: UILabel!
    @IBOutlet weak var facebookButtonTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var gotoRegistrationButton: UIButton!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var defaultFacebookButtonTopSpaceConstraintConstant: CGFloat?
    var defaultlogoTopSpaceConstraintConstant: CGFloat?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if screenSize.height <= 568  {
            self.facebookButtonTopSpaceConstraint.constant = 80
        }
        
        self.defaultFacebookButtonTopSpaceConstraintConstant = self.facebookButtonTopSpaceConstraint.constant
        self.defaultlogoTopSpaceConstraintConstant = self.logoTopSpaceConstraint.constant
        
        self.emailTextField.leftViewImage = #imageLiteral(resourceName: "mail-icon")
        self.emailTextField.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight)
        self.emailTextField.autocorrectionType = .no
        
        self.passwordTextField.leftViewImage = #imageLiteral(resourceName: "password-icon")
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight)
        
        //Localization
        self.loginButton.setTitle("LOGIN".localized, for: .normal)
        self.loginButton.setTitle("LOGIN".localized, for: .selected)
        self.orLabel.text = "OR".localized
        self.emailTextField.placeholder = "EMAIL".localized
        self.passwordTextField.placeholder = "PASSWORD".localized
        
        let text1 = "NO_ACCOUNT_LABEL".localized + " "
        let text2 = "REGISTER_BUTTON".localized
        let mutableString = NSMutableAttributedString(
            string: text1 + text2,
            attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 17)])
        
        mutableString.addAttribute(NSForegroundColorAttributeName, value: customDarkGray, range: NSMakeRange(0, text1.characters.count))
        mutableString.addAttribute(NSForegroundColorAttributeName, value: orange, range: NSMakeRange(text1.characters.count, text2.characters.count))
        self.gotoRegistrationButton.setAttributedTitle(mutableString, for: .normal)
        self.gotoRegistrationButton.setAttributedTitle(mutableString, for: .selected)
        self.gotoRegistrationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Button handler
    
    func backgroundTap() {
        self.view.endEditing(true)
    }

    @IBAction func handleRegistrationButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "registrationSegue", sender: self)
    }
    
    @IBAction func handleLoginBUttonTapped(_ sender: AnyObject) {
        
        let mail = self.emailTextField.text
        let password = self.passwordTextField.text
        
        let parameters: [String : String] = [
            "email": mail!,
            "password": password!
        ]
        
        let requestURL = baseURL + "auth/sign_in/"
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response.result.value)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                switch json["status"] {
                case "error":
                    print(json["errors"])
                    break
                default:
                    print(json["errors"])
                }
                
                break
            case .failure(let error):
                
                print(error)
            }
            
        }
        
        self.performSegue(withIdentifier: "navigationControllerSegue", sender: self)

    }
    
    @IBAction func facebookButton(_ sender: AnyObject) {
        
    }
    
    // MARK: - Keyboard animation handling
    
    func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        var topSpace:CGFloat = 34
        var facebookTopSpace:CGFloat = 33
        
        if screenSize.height <= 568  {
            topSpace = 0
            facebookTopSpace = 0
        }
        
        self.facebookButtonTopSpaceConstraint.constant = moveUp ? facebookTopSpace : self.defaultFacebookButtonTopSpaceConstraintConstant!
        let alpha = moveUp ? 0 : 1 as CGFloat
        self.logoTopSpaceConstraint.constant = moveUp ? topSpace : self.defaultlogoTopSpaceConstraintConstant!
        
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
