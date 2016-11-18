//
//  PaymentSelectionView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

enum Payment {
    case none
    case itunes
    case payPal
    case creditCard
}

class PaymentSelectionView: UIView {
    @IBOutlet weak var payPalImageView: UIImageView!
    @IBOutlet var view: UIView!
    @IBOutlet weak var itunesImageView: UIImageView!
    @IBOutlet weak var creditCardImageView: UIImageView!
    
    public var selectedPayment = Payment.none
    
    public var callback: (() -> Void)!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

        UINib(nibName: "PaymentSelectionView", bundle: nil).instantiate(withOwner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        self.payPalImageView.layer.cornerRadius = 5
        self.payPalImageView.layer.borderColor = customDarkerGray.cgColor
        self.payPalImageView.layer.borderWidth = 1
        self.payPalImageView.isUserInteractionEnabled = true
        
        self.itunesImageView.layer.cornerRadius = 5
        self.itunesImageView.layer.borderColor = customDarkerGray.cgColor
        self.itunesImageView.layer.borderWidth = 1
        self.itunesImageView.isUserInteractionEnabled = true
        
        self.creditCardImageView.layer.cornerRadius = 5
        self.creditCardImageView.layer.borderColor = customDarkerGray.cgColor
        self.creditCardImageView.layer.borderWidth = 1
        self.creditCardImageView.isUserInteractionEnabled = true
        self.creditCardImageView.backgroundColor = .white
        self.creditCardImageView.isUserInteractionEnabled = true
        
        let payPalTap = UITapGestureRecognizer(target: self, action: #selector(payPalTapped))
        let itunesTap = UITapGestureRecognizer(target: self, action: #selector(itunesTapped))
        let creditCardTap = UITapGestureRecognizer(target: self, action: #selector(creditCardTapped))
        
        self.payPalImageView.addGestureRecognizer(payPalTap)
        self.itunesImageView.addGestureRecognizer(itunesTap)
        self.creditCardImageView.addGestureRecognizer(creditCardTap)
    }
    
    func payPalTapped() {
        self.selectedPayment = Payment.payPal
        self.payPalImageView.layer.borderColor = orange.cgColor
        self.itunesImageView.layer.borderColor = customDarkerGray.cgColor
        self.creditCardImageView.layer.borderColor = customDarkerGray.cgColor
        self.callback()
    }
    
    func itunesTapped() {
        self.selectedPayment = Payment.itunes
        self.itunesImageView.layer.borderColor = orange.cgColor
        self.payPalImageView.layer.borderColor = customDarkerGray.cgColor
        self.creditCardImageView.layer.borderColor = customDarkerGray.cgColor
        self.callback()
    }
    
    func creditCardTapped() {
        self.selectedPayment = Payment.creditCard
        self.creditCardImageView.layer.borderColor = orange.cgColor
        self.itunesImageView.layer.borderColor = customDarkerGray.cgColor
        self.payPalImageView.layer.borderColor = customDarkerGray.cgColor
        self.callback()
    }

}
