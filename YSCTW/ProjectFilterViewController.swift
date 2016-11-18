//
//  ProjectFilterViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectFilterViewController: UIViewController {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    public var topicCallback: (() -> Void)!
    public var countryCallback: (() -> Void)!
    
    var picker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spacerView.backgroundColor = customDarkerGray
        self.leftView.backgroundColor = customLightGray
        self.rightView.backgroundColor = customLightGray
        
        self.leftLabel.backgroundColor = .clear
        self.rightLabel.backgroundColor = .clear
        self.view.backgroundColor = customLightGray
        
        //Localization
        self.leftLabel.text = "ALL".localized
        self.rightLabel.text = "ALL".localized
        self.leftLabel.textColor = navigationBarGray
        self.rightLabel.textColor = navigationBarGray
        
        self.leftLabel.adjustsFontSizeToFitWidth = true
        self.rightLabel.adjustsFontSizeToFitWidth = true
        
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(handleLeftTap))
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(handleRightTap))
        
        self.leftView.addGestureRecognizer(tapLeft)
        self.rightView.addGestureRecognizer(tapRight)
    }
    
    func handleLeftTap() {
        self.topicCallback()
    }
    
    func handleRightTap() {
        self.countryCallback()
    }
    
}
