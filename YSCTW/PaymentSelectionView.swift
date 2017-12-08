//
//  PaymentSelectionView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PaymentSelectionView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var payPalView: UIView!
    @IBOutlet weak var creditCardView: UIView!

    public var selectedPayment = Payment.none
    
    public var callback: ((_ paymentType: Payment) -> Void)!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        UINib(nibName: "PaymentSelectionView", bundle: nil).instantiate(withOwner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        self.payPalView.layer.cornerRadius = 5
        self.payPalView.layer.borderColor = customDarkerGray.cgColor
        self.payPalView.layer.borderWidth = 1
        self.payPalView.isUserInteractionEnabled = true
        self.payPalView.backgroundColor = .white
        
        self.creditCardView.layer.cornerRadius = 5
        self.creditCardView.layer.borderColor = customDarkerGray.cgColor
        self.creditCardView.layer.borderWidth = 1
        self.creditCardView.isUserInteractionEnabled = true
        self.creditCardView.backgroundColor = .white
        
        let payPalTap = UITapGestureRecognizer(target: self, action: #selector(payPalTapped))
        let creditCardTap = UITapGestureRecognizer(target: self, action: #selector(creditCardTapped))
        
        self.payPalView.addGestureRecognizer(payPalTap)
        self.creditCardView.addGestureRecognizer(creditCardTap)
    }
    
    @objc func payPalTapped() {
        self.selectedPayment = Payment.payPal
        self.payPalView.layer.borderColor = orange.cgColor
        self.creditCardView.layer.borderColor = customDarkerGray.cgColor
        self.callback(self.selectedPayment)
    }
    
    @objc func creditCardTapped() {
        self.selectedPayment = Payment.creditCard
        self.creditCardView.layer.borderColor = orange.cgColor
        self.payPalView.layer.borderColor = customDarkerGray.cgColor
        self.callback(self.selectedPayment)
    }

}
