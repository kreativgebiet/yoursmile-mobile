//
//  CornerButtons.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class CornerButton: UIButton {

    public var corners : UIRectCorner?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
        
        self.layer.shadowColor = customGray.cgColor
        self.layer.shadowOffset = CGSize(width: 20, height: 10)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 50.0
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let maskLayer = CAShapeLayer()
        
        if self.corners != nil {
            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: self.corners!, cornerRadii: CGSize(width: 5, height: 5)).cgPath
            self.layer.mask = maskLayer
        } else {
            maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
            self.layer.mask = maskLayer
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = maskLayer.path
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = customGray.cgColor
        shapeLayer.lineWidth = 0.5;
        
        self.layer.addSublayer(shapeLayer)
    }
    
}
