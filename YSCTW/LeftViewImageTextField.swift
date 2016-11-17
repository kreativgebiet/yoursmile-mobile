//
//  LeftViewImageTextField.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class LeftViewImageTextField: UITextField {
    
    public var leftViewImage: UIImage? {
        didSet {
            self.leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.size.height))
            imageView.image = self.leftViewImage
            imageView.contentMode = .center
            self.leftView = imageView
        }
    }
    
    public var corners : UIRectCorner?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .white
        
        self.layer.shadowColor = customGray.cgColor
        self.layer.shadowOffset = CGSize(width: 20, height: 10)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 50.0
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 40, height: self.frame.size.height)
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
