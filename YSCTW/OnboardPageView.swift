//
//  OnboardPageView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 24.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class OnboardPageView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var bottomLabelText = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: "OnboardPageView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        
        view.frame = self.bounds
        
        self.bottomLabel.textColor = timeGray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: bottomLabelText)
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        bottomLabel.attributedText = attrString        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
