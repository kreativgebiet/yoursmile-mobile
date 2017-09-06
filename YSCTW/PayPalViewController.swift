//
//  PayPalPaymentManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 23.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class PayPalViewController: UIViewController, PayPalPaymentDelegate {
    
    public var callback: ((_ upload: UploadModel?, _ success: Bool, _ error: String) -> ())!
    
    var payPalConfig = PayPalConfiguration()
    
    public func showPayPalPaymentFor(amount: Float, fee: Float, projects: [Project], paymentDict: [String : Float]) -> () {
        
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "YSCTW GmbH"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = LanguageManager.sharedInstance.getSelectedLocale()
        
        var items = [PayPalItem]()
        
        for project in projects {
            let price = paymentDict[project.id]
            let priceString = "\(Int(price!))"
            
            let item = PayPalItem(name: (project.projectName as NSString) as String, withQuantity: 1, withPrice: NSDecimalNumber(string: priceString), withCurrency: "EUR", withSku: (project.projectName as NSString) as String)
            items.append(item)
        }
        
        
        let handler = NSDecimalNumberHandler(roundingMode: .up, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        
        let decimalAmount = NSDecimalNumber(value: amount)
        let roundedAmount = decimalAmount.rounding(accordingToBehavior: handler)
        
        let decimalFee = NSDecimalNumber(value: fee)
        let roundedFee = decimalFee.rounding(accordingToBehavior: handler)
        
        let paymentDetails = PayPalPaymentDetails(subtotal: roundedAmount, withShipping: NSDecimalNumber(value: 0), withTax: roundedFee)
        
        let total = roundedAmount.adding(roundedFee)
        
        let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Donation", intent: .sale)
        payment.paymentDetails = paymentDetails
        payment.items = items
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)            
            self.present(paymentViewController!, animated: false, completion: nil)
        } else {
            print("Payment not processalbe: \(payment)")
            
        }
    }
    
    // MARK: PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        self.callback(nil, false, "Canceled")
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in            
            self.dismiss(animated: true, completion: nil)
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
            let controller = CoreDataController()
            let uploadModel = controller.createUploadModel()
            uploadModel.isStripePayment = NSNumber(booleanLiteral: false) as! Bool
            uploadModel.stripeToken = ""
            uploadModel.isUploaded = NSNumber(booleanLiteral: false) as! Bool
            
            controller.save()
            
            self.callback(uploadModel, true, "")
        })
    }
    
}
