//
//  LaunchAnimationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 25.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class LaunchAnimationViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var logoImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: "SMILE&\nCHANGE");
        
        let range = attributedString.mutableString.range(of: "SMILE&\n", options:NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: blue, range: range)
        }
        
        let range2 = attributedString.mutableString.range(of: "CHANGE", options:NSString.CompareOptions.caseInsensitive)
        if range2.location != NSNotFound {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: blue2, range: range2)
        }
        
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Zufo-Regular", size: 72)!, range: NSMakeRange(0, attributedString.length))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 20
        paragraphStyle.maximumLineHeight = 58.0/2.0
        paragraphStyle.alignment = NSTextAlignment.center
        
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(6), range: NSRange(location: 0, length: attributedString.length))


        label.attributedText = attributedString
        label.alpha = 0
        logoImage.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.7, animations: {
            self.logoImage.alpha = 1
        }) { (completed) in
            UIView.animate(withDuration: 0.7, animations: {
                self.label.alpha = 1
            })
        }
    }

}
