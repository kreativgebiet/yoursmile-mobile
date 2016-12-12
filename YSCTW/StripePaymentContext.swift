//
//  StripePaymentContext.swift
//  YSCTW
//
//  Created by Max Zimmermann on 28.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Stripe

class StripePaymentContext: NSObject, STPPaymentContextDelegate {
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
//        self.activityIndicator.animating = paymentContext.loading
//        self.paymentButton.enabled = paymentContext.selectedPaymentMethod != nil
//        self.paymentLabel.text = paymentContext.selectedPaymentMethod?.label
//        self.paymentIcon.image = paymentContext.selectedPaymentMethod?.image
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
//        myAPIClient.createCharge(paymentResult.source.stripeID, completion: { (error: Error?) in
//            if let error = error {
//                completion(error)
//            } else {
//                completion(nil)
//            }
//        })
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFinishWith status: STPPaymentStatus,
                        error: Error?) {
        
//        switch status {
//        case .error:
//            self.showError(error)
//        case .success:
//            self.showReceipt()
//        case .userCancellation:
//            return // Do nothing
//        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFailToLoadWithError error: Error) {
//        self.navigationController?.popViewController(animated: true)
        // Show the error to your user, etc.
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
//    let upsGround = PKShippingMethod()
//    upsGround.amount = 0
//    upsGround.label = "UPS Ground"
//    upsGround.detail = "Arrives in 3-5 days"
//    upsGround.identifier = "ups_ground"
//    let fedEx = PKShippingMethod()
//    fedEx.amount = 5.99
//    fedEx.label = "FedEx"
//    fedEx.detail = "Arrives tomorrow"
//    fedEx.identifier = "fedex"
//    
//    if address.country == "US" {
//    completion(.valid, nil, [upsGround, fedEx], upsGround)
//    }
//    else {
//    completion(.invalid, nil, nil, nil)
//    }
    }

}
