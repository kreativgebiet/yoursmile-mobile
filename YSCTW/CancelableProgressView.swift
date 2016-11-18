//
//  CancelableProgressView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 18.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class CancelableProgressView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet var view: UIView!
    
    public var cancel: (() -> Void)!
    
    var progress: Float {
        set {
            self.progressView.progress = newValue
        }
        
        get {
            return self.progressView.progress
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "CancelableProgressView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.backgroundColor = customGray
        
        self.imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelTap))
        self.imageView.addGestureRecognizer(tapGesture)
        
        self.progressView.layer.cornerRadius = 5
        self.progressView.clipsToBounds = true
    }
    
    func cancelTap() {
        cancel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view.backgroundColor = customLightGray
        
        self.progressView.trackTintColor = customDarkerGray
        self.progressView.progressTintColor = orange
    }

}
