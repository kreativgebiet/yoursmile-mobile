//
//  CardPaymentView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 29.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Stripe

class CardPaymentView: UIView, STPPaymentCardTextFieldDelegate {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var cardOwnerTitleLabel: UILabel!
    @IBOutlet weak var cardOwnerNameTextField: UITextField!
    @IBOutlet weak var paymentCardTextFieldContainer: UIView!
    @IBOutlet weak var payButton: RoundedButton!
    @IBOutlet weak var cardNumberTitleLabel: UILabel!
    
    @IBOutlet weak var priceTitleContainerView: UIView!
    @IBOutlet weak var cardOwnerTitleContainerView: UIView!
    @IBOutlet weak var cardNumberTitleContainerView: UIView!
    
    var paymentField: STPPaymentCardTextField!
    var price: Float!
    
    public var callback: ((_ success: Bool) -> Void)!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        UINib(nibName: "CardPaymentView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.backgroundColor = customGray2
        
        priceTitleContainerView.backgroundColor = customGray2
        cardOwnerTitleContainerView.backgroundColor = customGray2
        cardNumberTitleContainerView.backgroundColor = customGray2
        
        self.cardOwnerTitleLabel.textColor = customMiddleGray
        self.cardNumberTitleLabel.textColor = customMiddleGray
        self.priceLabel.textColor = customMiddleGray
        self.cardOwnerNameTextField.textColor = navigationBarGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.priceLabel.text = String(format: "%@: %@ €", "PRICE".localized, String(Float(self.price/100.0).roundTo(places: 2)))
        
        self.payButton.setTitle("PAY".localized, for: .normal)
        self.payButton.setTitle("PAY".localized, for: .selected)
        
        self.cardNumberTitleLabel.text = "CARD_NUMBER".localized.uppercased()
        self.cardOwnerTitleLabel.text = "CARD_HOLDER".localized.uppercased()
        self.cardOwnerNameTextField.placeholder = "CARD_HOLDER".localized
        
        if self.paymentField == nil {
            self.paymentField = STPPaymentCardTextField(frame: self.paymentCardTextFieldContainer.bounds)
            self.paymentField.delegate = self
            self.paymentField.textColor = navigationBarGray
            self.paymentField.placeholderColor = placeholderColor
            self.paymentField.font = UIFont(name: "Gotham-Medium", size: 15)
            self.paymentField.cornerRadius = 0
            self.paymentField.borderColor = UIColor.clear
            self.paymentCardTextFieldContainer.addSubview(paymentField)
        }
        
        self.paymentField.frame = self.paymentCardTextFieldContainer.bounds
    }
    
    @IBAction func payButtonPressed(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if self.paymentField.isValid {
            self.callback(true)
        } else {
            self.callback(false)
        }
        
    }
    
    // MARK: - Payment Field Delegates

    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
    }

}
