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

class LoginViewController: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextField: LeftViewImageTextField!
    @IBOutlet weak var passwordTextField: LeftViewImageTextField!
    @IBOutlet weak var facebookButtonTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var gotoRegistrationButton: UIButton!
    @IBOutlet weak var gotoPasswordResetButton: UIButton!
    @IBOutlet weak var loginButton: RoundedButton!
    @IBOutlet weak var orLabel: UILabel!
    
    var defaultFacebookButtonTopSpaceConstraintConstant: CGFloat?
    var defaultlogoTopSpaceConstraintConstant: CGFloat?
    
    var loadingScreen: LoadingScreen!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.backgroundColor = blue
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        if screenSize.height <= 568  {
            self.facebookButtonTopSpaceConstraint.constant = 80
        }
        
        self.googleLoginButton.layer.cornerRadius = 4
        
        self.facebookLoginButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.defaultFacebookButtonTopSpaceConstraintConstant = self.facebookButtonTopSpaceConstraint.constant
        self.defaultlogoTopSpaceConstraintConstant = self.logoTopSpaceConstraint.constant
        
        self.emailTextField.leftViewImage = #imageLiteral(resourceName: "mail-icon")
        self.emailTextField.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight)
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.text = ""
        self.emailTextField.delegate = self
        
        self.passwordTextField.leftViewImage = #imageLiteral(resourceName: "password-icon")
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight)
        self.passwordTextField.text = ""
        self.passwordTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let loggedIn = UserDefaults.standard.value(forKey: "loggedIn") as? Bool {
            if loggedIn == true {
                DispatchQueue.main.async {
                    self.view.isHidden = true
                    self.performSegue(withIdentifier: "navigationControllerSegue", sender: self)
                }
            }
        }
        
        self.loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        
        //Localization
        self.loginButton.setTitle("LOGIN".localized, for: .normal)
        self.loginButton.setTitle("LOGIN".localized, for: .selected)
        
        self.facebookLoginButton.setTitle("LOGIN_WITH_FB".localized, for: .normal)
        self.facebookLoginButton.setTitle("LOGIN_WITH_FB".localized, for: .selected)
        
        self.orLabel.text = "OR".localized
        self.emailTextField.placeholder = "EMAIL".localized
        self.passwordTextField.placeholder = "PASSWORD".localized
        
        let text1 = "NO_ACCOUNT_LABEL".localized + " "
        let text2 = "REGISTER_BUTTON".localized
        
        let mutableString = NSMutableAttributedString(
            string: text1 + text2)
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: customDarkGray, range: NSMakeRange(0, text1.count))
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: orange, range: NSMakeRange(text1.count, text2.count))
        
        self.gotoRegistrationButton.setAttributedTitle(mutableString, for: .normal)
        self.gotoRegistrationButton.setAttributedTitle(mutableString, for: .selected)
        self.gotoRegistrationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let text3 = "PASSWORD_RESET_LABEL".localized + " "
        let text4 = "PASSWORD_BUTTON".localized
        
        let mutableString2 = NSMutableAttributedString(
            string: text3 + text4)
        mutableString2.addAttribute(NSAttributedStringKey.foregroundColor, value: customDarkGray, range: NSMakeRange(0, text3.count))
        mutableString2.addAttribute(NSAttributedStringKey.foregroundColor, value: orange, range: NSMakeRange(text3.count, text4.count))
        
        self.gotoPasswordResetButton.setAttributedTitle(mutableString2, for: .normal)
        self.gotoPasswordResetButton.setAttributedTitle(mutableString2, for: .selected)
        self.gotoPasswordResetButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Button handler
    
    @objc func backgroundTap() {
        self.view.endEditing(true)
    }

    @IBAction func handleRegistrationButtonTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "registrationSegue", sender: self)
    }
    
    @IBAction func handleLoginBUttonTapped(_ sender: AnyObject) {
        
        let mail = self.emailTextField.text
        let password = self.passwordTextField.text
        
        var errorMessage = ""
        
        if !(mail?.isValidEmail)! {
            errorMessage = errorMessage + "MAIL_ERROR".localized + " "
        }
        
        if (password?.count)! < 8 {
            errorMessage = errorMessage + "PASSWORD_ERROR".localized
        }
        
        if errorMessage.count > 0 {
            HelperFunctions.presentAlertViewfor(error: errorMessage)
            return
        }
        
        self.view.endEditing(true)
        self.view.addSubview(self.loadingScreen)
        
        self.loginWith(mail!, password!)
    }
    
    @IBAction func handleGotoPasswordResetTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "passwordResetSegue", sender: self)
    }
    
    func loginWith(_ email: String, _ password: String) {
        
        if self.loadingScreen.superview == nil {
            self.view.addSubview(self.loadingScreen)
        }
        
        let callback = { (success: Bool) in
            self.loadingScreen.removeFromSuperview()
            if success {
                self.performSegue(withIdentifier: "navigationControllerSegue", sender: self)
            }
        }
        
        DataManager().login(email: email, password: password, callback)
        

    }
    
    // MARK: - Google Login
    
    @IBAction func handleGoogleButtonTap(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            let fullName = user.profile.name
            let email = user.profile.email
            
            APIClient.registerUser(name: fullName!, email: email!, password: "google1234", callback: { (success: Bool, errorMessage: String) in
                
                if success == true {
                    self.loginWith(email!, "google1234")
                } else {
                    
                    if (errorMessage == "Email already in use") {
                        self.loadingScreen.removeFromSuperview()
                        self.loginWith(email!, "google1234")
                    } else {
                        HelperFunctions.presentAlertViewfor(error: errorMessage)
                    }
                    
                }
                
            })
            
            
        } else {
            HelperFunctions.presentAlertViewfor(error: "NO_MAIL_FB_LOGIN".localized)
        }
    }
    
    // MARK: - Facebook Login
    
    @IBAction func facebookButton(_ sender: AnyObject) {

        self.view.endEditing(true)
        self.view.addSubview(loadingScreen)

        let loginmanager = FBSDKLoginManager()
        loginmanager.logIn(withReadPermissions: ["public_profile", "user_birthday", "email"], from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
            
            if ((error) != nil) {
                
                DispatchQueue.main.async {
                    self.loadingScreen.removeFromSuperview()
                    HelperFunctions.presentAlertViewfor(error: (error?.localizedDescription)!)
                }

            } else if (result?.isCancelled)! {
                self.loadingScreen.removeFromSuperview()
            } else {
    
                if (result?.grantedPermissions.contains("email") )!{
                    
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, name"])
                    graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                        
                        if ((error) != nil) {
                            self.loadingScreen.removeFromSuperview()
                            print("Error: \(String(describing: error))")
                        } else {
                            let dict = result as! [String : String]

                            guard let userName = dict["name"] as NSString?, let userEmail = dict["email"] as NSString? else {
                                HelperFunctions.presentAlertViewfor(error: "An unknown error occured!")
                                return
                            }
                            
                            APIClient.registerUser(name: userName as String, email: userEmail as String, password: "facebook1234", callback: { (success: Bool, errorMessage: String) in
                                
                                if success == true {
                                    self.loginWith(userEmail as String, "facebook1234")
                                } else {
                                    
                                    if (errorMessage == "Email already in use") {
                                        self.loadingScreen.removeFromSuperview()
                                        self.loginWith(userEmail as String, "facebook1234")
                                    } else {
                                        HelperFunctions.presentAlertViewfor(error: errorMessage)
                                    }
                                    
                                }
                                
                            })
                            
                            
                        }
                    })
                    
                    
                } else {
                    HelperFunctions.presentAlertViewfor(error: "NO_MAIL_FB_LOGIN".localized)
                }
            }
            
            
        }
        
    }
    
    
    // MARK: - TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField {
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
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    // MARK: - Keyboard animation handling
    
    @objc func animateWithKeyboard(notification: NSNotification) {
        
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
        self.logoTopSpaceConstraint.constant = moveUp ? topSpace : self.defaultlogoTopSpaceConstraintConstant!
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options,
                       animations: {
                        self.view.layoutIfNeeded()
            },
                       completion: nil
        )
    }
}
