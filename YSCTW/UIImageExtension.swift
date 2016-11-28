//
//  UIImageExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 28.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

extension UIImage {
    
    func resizeImageTo(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        
        var actualHeight = self.size.height
        var actualWidth = self.size.width
        var imgRatio = actualWidth/actualHeight
        let maxRatio = maxWidth/maxHeight
        
        if (actualHeight > maxHeight || actualWidth > maxWidth) {
            if(imgRatio < maxRatio) {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            } else if(imgRatio > maxRatio) {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            } else {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect = CGRect(x: 0.0,y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
