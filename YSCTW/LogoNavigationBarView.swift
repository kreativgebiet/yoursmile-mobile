//
//  LogoNavigationBarView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 14.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class LogoNavigationBarView: UIView {

    var logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo-white"))
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let height = frame.size.height
        let width = frame.size.width
        
        logoImageView.frame = CGRect(x: height/2, y: 0, width: height, height: height)
        logoImageView.contentMode = .scaleAspectFit
        
        self.addSubview(logoImageView)

        titleLabel.frame = CGRect(x: height, y: 0, width: width-height, height: height)
        titleLabel.text = "YSCTW"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .right
        
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
