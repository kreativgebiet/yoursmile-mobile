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

class StripePaymentViewController: UIViewController, STPPaymentContextDelegate {
    
    @IBOutlet weak var cardPaymentView: CardPaymentView!
    
    var paymentContext: STPPaymentContext?
    public var totalPrice: Int!
    public var callback: ((_ success: Bool, _ error: String) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let config = STPPaymentConfiguration.shared()
//        config.publishableKey =
//        config.companyName = "YSCTW GmbH"
//        config.requiredBillingAddressFields = STPBillingAddressFields.full
//        config.requiredShippingAddressFields = .name
//        config.additionalPaymentMethods = STPPaymentMethodType()
//        config.smsAutofillDisabled = false
//        
//        self.paymentContext? = STPPaymentContext(apiAdapter: StripeBackendApiClient.sharedClient,
//                                                 configuration: config,
//                                                 theme: STPTheme.default())
//        
//        let userInformation = STPUserInformation()
//        
//        self.paymentContext?.prefilledInformation = userInformation
//        self.paymentContext?.paymentAmount = self.totalPrice
//        self.paymentContext?.paymentCurrency = "EUR"
//        
//        self.paymentContext?.delegate = self
//        self.paymentContext?.hostViewController = self
//        
        self.cardPaymentView.price = Float(totalPrice)
        
        self.cardPaymentView.callback = { success in
            
            if success {
                
                // If you have your own form for getting credit card information, you can construct
                // your own STPCardParams from number, month, year, and CVV.
                let card = self.cardPaymentView.paymentField.cardParams
                
                STPAPIClient.shared().createToken(withCard: card) { token, error in
                    guard let stripeToken = token else {
                        NSLog("Error creating token: %@", error!.localizedDescription);
                        return
                    }
                    
                    // TODO: send the token to your server so it can create a charge
                    let alert = UIAlertController(title: "Welcome to Stripe", message: "Token created: \(stripeToken)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
                    print(dictionary)

                    
                    APIClient.postPaymentSource((token?.tokenId)!, { (success, errorMessage) in
                        
                        self.callback(true, "")
                    
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

    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        StripeBackendApiClient.sharedClient.completeCharge(paymentResult, amount: (self.paymentContext?.paymentAmount)!,
                                                completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
//        self.paymentInProgress = false
//        let title: String
//        let message: String
//        switch status {
//        case .error:
//            title = "Error"
//            message = error?.localizedDescription ?? ""
//        case .success:
//            title = "Success"
//            message = "You bought a \(self.product)!"
//        case .userCancellation:
//            return
//        }
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alertController.addAction(action)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//        self.paymentRow.loading = paymentContext.loading
//        if let paymentMethod = paymentContext.selectedPaymentMethod {
//            self.paymentRow.detail = paymentMethod.label
//        }
//        else {
//            self.paymentRow.detail = "Select Payment"
//        }
//        if let shippingMethod = paymentContext.selectedShippingMethod {
//            self.shippingRow.detail = shippingMethod.label
//        }
//        else {
//            self.shippingRow.detail = "Enter \(self.shippingString) Info"
//        }
//        self.totalRow.detail = self.numberFormatter.string(from: NSNumber(value: Float(self.paymentContext.paymentAmount)/100))!
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext?.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
