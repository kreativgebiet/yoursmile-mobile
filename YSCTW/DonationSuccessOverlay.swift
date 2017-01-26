//
//  DonationSuccessOverlay.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationSuccessOverlay: UIView {

    @IBOutlet weak var gratitudeLabel: UILabel!
    @IBOutlet var view: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var gratitudeTextLabel: UILabel!
    @IBOutlet weak var backButton: RoundedButton!
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
        
        self.backButton.setTitle("THANK_YOU_BUTTON".localized, for: .normal)
        self.backButton.setTitle("THANK_YOU_BUTTON".localized, for: .selected)
        
        self.gratitudeLabel.text = "THANK_YOU".localized
        self.gratitudeLabel.textColor = navigationBarGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: "THANK_YOU_TEXT".localized)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        self.gratitudeTextLabel.attributedText = attrString

        self.gratitudeTextLabel.textColor = green
    }
    
    @IBAction func handleButtonPressed(_ sender: AnyObject) {
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
