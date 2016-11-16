//
//  RoundedButton.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = orange
        self.setTitleColor(.white, for: .normal)
        
        self.layer.cornerRadius = 5
    }

}
