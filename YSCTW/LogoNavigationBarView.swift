//
//  LogoNavigationBarView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 14.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class LogoNavigationBarView: UIView {

    var logoImageView = UIImageView(image: #imageLiteral(resourceName: "navbar-logo"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let height = frame.size.height
        let width = frame.size.width
        
        logoImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        logoImageView.contentMode = .scaleAspectFit
        
        self.addSubview(logoImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
