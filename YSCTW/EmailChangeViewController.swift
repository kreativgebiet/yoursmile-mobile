//
//  EmailChangeViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class EmailChangeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailConfirmationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = customLightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.titleLabel.text = "NEW_EMAIL".localized
        self.emailTextField.placeholder = "NEW_EMAIL_PH".localized
        self.emailConfirmationTextField.placeholder = "NEW_EMAIL_CONFIRMATION_PH".localized

        self.saveButton.setTitle("SAVE".localized, for: .normal)
        self.saveButton.setTitle("SAVE".localized, for: .selected)
    }

    @IBAction func handleEmailAdresseButtonTapped(_ sender: AnyObject) {
        
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
