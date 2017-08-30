
//
//  InsetTextfield.swift
//  YSCTW
//
//  Created by Max Zimmermann on 30.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class InsetTextfield: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 12);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
