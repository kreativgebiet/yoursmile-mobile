//
//  UILabelExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 30.03.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

extension UILabel{
    
    func adjustFontSizeToFitRect(rect : CGRect){
        
        if text == nil{
            return
        }
        
        frame = rect
        
        let maxFontSize: CGFloat = 100.0
        let minFontSize: CGFloat = 10
        
        var q = Int(maxFontSize)
        var p = Int(minFontSize)
        
        let constraintSize = CGSize(width: rect.width, height: CGFloat.greatestFiniteMagnitude)
        
        while(p <= q){
            let currentSize = (p + q) / 2
            font = font.withSize( CGFloat(currentSize) )
            let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:font])
            let textRect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)
            
            let labelSize = textRect.size
            
            if labelSize.height < frame.height && labelSize.height >= frame.height-10 && labelSize.width < frame.width && labelSize.width >= frame.width-10 {
                break
            }else if labelSize.height > frame.height || labelSize.width > frame.width{
                q = currentSize - 1
            }else{
                p = currentSize + 1
            }
        }
        
    }
}
