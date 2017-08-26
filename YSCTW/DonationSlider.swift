//
//  DonationSlider.swift
//  YSCTW
//
//  Created by Max Zimmermann on 30.03.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

class DonationSlider : UISlider {
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 8.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        var thumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value:  value)
        
        thumbRect.origin.y += 2
        
        if value == self.minimumValue {
            thumbRect.origin.x -= 2
        } else if value == self.maximumValue {
            thumbRect.origin.x += 6
        }
        
        return thumbRect
    }
    
    override func awakeFromNib() {
        self.setThumbImage(#imageLiteral(resourceName: "donation-slider-thumb"), for: .normal)
        
        self.minimumTrackTintColor = blue
        self.maximumTrackTintColor = gray224
        
        self.tintColor = blue
        super.awakeFromNib()
    }
}
