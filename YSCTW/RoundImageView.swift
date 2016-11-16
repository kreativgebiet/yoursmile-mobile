//
//  RoundImageView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 14.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        
        self.layer.cornerRadius = radius
    }

}
