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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = self.loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        view.backgroundColor = navigationBarGray.withAlphaComponent(0.6)
        self.infoView.backgroundColor = .white
        self.infoView.layer.cornerRadius = 10
        
        self.button.setTitle("FEE_BUTTON".localized, for: .normal)
        self.button.setTitle("FEE_BUTTON".localized, for: .selected)
        
        self.paymentLabel.text = "FEE_TITLE".localized
        self.paymentLabel.textColor = navigationBarGray
        
        self.paymentDescriptionLabel.text = "FEE_TEXT".localized
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
