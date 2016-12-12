//
//  ProgressView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    
    //Progress expected in range of [0:1]
    public var progress: Float {
        set {
            self.progressView.progress = newValue
        }
        
        get {
            return self.progressView.progress
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "ProgressView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        
        self.progressView.layer.cornerRadius = 5
        self.progressView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view.backgroundColor = customLightGray
        self.progressLabel.textColor = spacerGray
        
        self.progressView.trackTintColor = customDarkerGray
        self.progressView.progressTintColor = orange
        
        let progessAsInt = Int(self.progress * 100)
        
        self.progressLabel.text = "TARGET_REACHED1".localized + " " + String(progessAsInt) + "%" + " " + "TARGET_REACHED2".localized
    }

}
