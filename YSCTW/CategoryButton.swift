//
//  CategoryButton.swift
//  YSCTW
//
//  Created by Max Zimmermann on 16.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class CategoryButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    func layout() {
        self.backgroundColor = .white
        self.setTitleColor(blue, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderColor = gray156.cgColor
        self.layer.borderWidth = 1
    }

}
