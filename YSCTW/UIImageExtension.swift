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
    
    func addOverlay() -> UIImage {
        
        //Text and Logo are drawn to the left lower corner of the initial image
        
        let textWidth = self.size.width * 0.22
        var textHeight = self.size.height * 0.06
        
        let padding = self.size.height * 0.03
        
        let margin = UIEdgeInsetsMake(0, padding, padding, 0)
        
        let testLabel = UILabel(frame: CGRect(x: 0, y: 0, width: textWidth, height: textHeight))
        testLabel.font = UIFont(name: "Gotham-Medium", size: 10)!
        testLabel.text = hashTag
        testLabel.adjustFontSizeToFitRect(rect: testLabel.frame)
        testLabel.sizeToFit()
        
        textHeight = testLabel.frame.height
        
        let textImage = self.textToImage(drawText: hashTag as NSString, withFont: testLabel.font, atPoint: CGPoint(x: margin.left, y: self.size.height - margin.bottom - textHeight))
        
        let overlayLogo = #imageLiteral(resourceName: "logo-white-big")
        let overlayLogoSize = overlayLogo.size
        
        let overlayLogoWidth = self.size.height * 0.25
        let overlayLogoHeight = overlayLogoSize.height/overlayLogoSize.width * overlayLogoWidth
        
        let overlayLogoRect = CGRect(x: margin.left, y: self.size.height - overlayLogoHeight - margin.bottom - textHeight, width: overlayLogoWidth, height: overlayLogoHeight)
        
        let overlayImage = textImage.drawImage(byDrawingImage: overlayLogo, inRect: overlayLogoRect)
        
        return overlayImage!
    }
    
    func textToImage(drawText text: NSString, withFont font: UIFont, atPoint point: CGPoint) -> UIImage {
        
        let textColor = UIColor.white
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor
            ] as [String : Any]
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        let rect = CGRect(origin: point, size: self.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func drawImage(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }

}
