//
//  AddProjectButton.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class AddProjectButton: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    public var callback: (() -> Void)!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "AddProjectButton", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        self.layer.borderColor = customDarkerGray.cgColor
        self.layer.borderWidth = 1
    }
    
    @IBAction func handleViewTapped(_ sender: AnyObject) {
        self.callback()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
