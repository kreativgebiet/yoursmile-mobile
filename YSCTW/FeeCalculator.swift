//
//  FeeCalculator.swift
//  YSCTW
//
//  Created by Max Zimmermann on 23.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class FeeCalculator: NSObject {
    
    class func calculateFeeForPaymentAmount(amount: Float, paymentType: Payment) -> Float {

        var fee:Float = 0
        
        if paymentType == .payPal {
            //https://www.paypal.com/webapps/mpp/paypal-fees
            //1.9 % + 0.35€
            fee = amount*0.019 + 0.35
        } else if paymentType == .creditCard {
            //https://stripe.com/de/pricing
            fee = amount*0.014 + 0.25
        } else {
            fee = 0
        }
        
        return fee.roundTo(places: 2)
    }
    
}
