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
        self.titleLabel?.font = UIFont(name: "Gotham-Medium", size: 18)
        self.backgroundColor = .white
        self.setTitleColor(gray156, for: .normal)
        self.layer.cornerRadius = 4
        self.layer.borderColor = gray221.cgColor
        self.layer.borderWidth = 0.5
    }

}
