//
//  DonationDetailOverlayView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDetailOverlayView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBOutlet weak var reportButton: CornerButton!
    @IBOutlet weak var cancelButton: CornerButton!
    @IBOutlet weak var instagramButton: CornerButton!
    @IBOutlet weak var facebookButton: CornerButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = self.loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        view.backgroundColor = navigationBarGray.withAlphaComponent(0.6)
        
        self.buttonContainerView.backgroundColor = customLightGray
        self.buttonContainerView.alpha = 1
        
        self.reportButton.setTitleColor(customRed, for: .normal)
        self.facebookButton.setTitleColor(navigationBarGray, for: .normal)
        self.instagramButton.setTitleColor(navigationBarGray, for: .normal)
        self.cancelButton.setTitleColor(navigationBarGray, for: .normal)
        
        self.reportButton.corners = UIRectCorner.topLeft.union(UIRectCorner.topRight)
        self.instagramButton.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight)
        self.cancelButton.corners = UIRectCorner.bottomLeft.union(UIRectCorner.bottomRight).union(UIRectCorner.topLeft).union(UIRectCorner.topRight)
        
        //Localization
        self.reportButton.setTitle("REPORT_COMMENT".localized, for: .normal)
        self.reportButton.setTitle("REPORT_COMMENT".localized, for: .selected)
        
        self.facebookButton.setTitle("SHARE_FACEBOOK".localized, for: .normal)
        self.facebookButton.setTitle("SHARE_FACEBOOK".localized, for: .selected)
        
        self.instagramButton.setTitle("SHARE_INSTAGRAM".localized, for: .normal)
        self.instagramButton.setTitle("SHARE_INSTAGRAM".localized, for: .selected)
        
        self.cancelButton.setTitle("CANCEL".localized, for: .normal)
        self.cancelButton.setTitle("CANCEL".localized, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func handleCancelButtonTapped(_ sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }

}
