//
//  DeleteAccountViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DeleteAccountViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: RoundedButton!
    
    public var callback: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customLightGray
        self.titleLabel.textColor = customMiddleGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.titleLabel.text = "DELETE_ACCOUNT".localized.uppercased()
        
        self.descriptionLabel.text = "DELETE_ACCOUNT_DESC".localized
        
        self.deleteButton.setTitle("DELETE_ACCOUNT".localized, for: .normal)
        self.deleteButton.setTitle("DELETE_ACCOUNT".localized, for: .selected)
    }

    @IBAction func handleDeleteAccountButtonTapped(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "INFORMATION".localized, message: "DELETE_ACCOUNT_DESC".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            
            let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
            
            self.view.endEditing(true)
            self.view.addSubview(loadingScreen)
            
            APIClient.deleteUser { (success: Bool, errorMessage: String) in
                loadingScreen.removeFromSuperview()
                
                if success {
                    NetworkHelper.deleteToken()
                    FBSDKLoginManager().logOut()
                    UserDefaults.standard.setValue(false, forKey: "loggedIn")
                    self.callback()
                } else {
                    HelperFunctions.presentAlertViewfor(error: errorMessage, presenter: self)
                }
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL".localized, style: .cancel) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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
