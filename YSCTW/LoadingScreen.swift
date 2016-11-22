//
//  LoadingScreen.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class LoadingScreen: UIView {
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = navigationBarGray.withAlphaComponent(0.4)
        
        self.activityIndicator.center = self.center
        self.activityIndicator.startAnimating()
    
        self.addSubview(self.activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
