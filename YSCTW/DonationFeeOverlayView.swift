//
//  DonationFeeOverlayView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationFeeOverlayView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var button: RoundedButton!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentDescriptionLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    public var callback: (() -> Void)!
    
    public init(frame: CGRect, numberOfProjects: Int, paymentType: Payment) {
        super.init(frame: frame)
        
        view = self.loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        view.backgroundColor = .clear
        self.infoView.backgroundColor = .white
        self.infoView.layer.cornerRadius = 10
        
        self.button.setTitle("FEE_BUTTON".localized, for: .normal)
        self.button.setTitle("FEE_BUTTON".localized, for: .selected)
        
        self.paymentLabel.text = "FEE_TITLE".localized
        self.paymentLabel.textColor = navigationBarGray
        
        let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: Float(numberOfProjects), paymentType: paymentType)
        
        let text = "FEE_TEXT".localized.replacingOccurrences(of: "%@", with: String(fee))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        self.paymentDescriptionLabel.attributedText = attrString
        
        self.paymentDescriptionLabel.textColor = green
    }

    @IBAction func buttonHandler(_ sender: AnyObject) {
        self.callback()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}
