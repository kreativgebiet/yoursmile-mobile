//
//  ProjectInfoView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 26.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ProjectInfoView: UIView {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var view: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "ProjectInfoView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
    }
}
