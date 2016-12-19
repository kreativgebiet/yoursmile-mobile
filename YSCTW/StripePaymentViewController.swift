//
//  StripePaymentViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 28.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Stripe
import Locksmith

class StripePaymentViewController: UIViewController {
    
    @IBOutlet weak var cardPaymentView: CardPaymentView!
    
    var paymentContext: STPPaymentContext?
    public var totalPrice: Int!
    public var callback: ((_ upload: UploadModel?, _ success: Bool, _ error: String) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cardPaymentView.price = Float(totalPrice)
        self.cardPaymentView.callback = { success in
            
            if success {
                
                let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
                self.view.addSubview(loadingScreen)
                
                // If you have your own form for getting credit card information, you can construct
                // your own STPCardParams from number, month, year, and CVV.
                let card = self.cardPaymentView.paymentField.cardParams
                
                STPAPIClient.shared().createToken(withCard: card) { token, error in
                    
                    guard let stripeToken = token else {
                        HelperFunctions.presentAlertViewfor(error: "ERROR".localized, presenter: self)
                        loadingScreen.removeFromSuperview()
                        self.callback(nil, false, "")
                        return
                    }

                    APIClient.postPaymentSource(stripeToken.tokenId, { (success, errorMessage) in
                        
                        loadingScreen.removeFromSuperview()
                        
                        if success {
                            let coreDataController = CoreDataController()
                            
                            let uploadModel = coreDataController.createUploadModel()
                            uploadModel.isStripePayment = NSNumber(booleanLiteral: true) as Bool
                            uploadModel.stripeToken = stripeToken.tokenId
                            uploadModel.isUploaded = NSNumber(booleanLiteral: false) as Bool
                            
                            coreDataController.save()
                            
                            self.callback(uploadModel, true, "")
                        } else {
                            HelperFunctions.presentAlertViewfor(error: "ERROR".localized, presenter: self)
                            self.callback(nil, false, "")
                        }

                    })
                
                }
                
            } else {
                HelperFunctions.presentAlertViewfor(error: "CREDIT_CARD_ERROR".localized, presenter: self)
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cardPaymentView.setNeedsLayout()
        self.cardPaymentView.layoutIfNeeded()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
