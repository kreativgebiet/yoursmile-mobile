//
//  ProjectButtonView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

protocol AddedProjectButtonDelegate {
    func delete(_ project: Project)
}

class AddedProjectButtonView: UIView {
    public var delegate: AddedProjectButtonDelegate!
    public var project: Project!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        
        self.layer.borderColor = customDarkerGray.cgColor
        self.layer.borderWidth = 1
        
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/2
        self.logoImageView.layer.borderColor = customDarkerGray.cgColor
        self.logoImageView.layer.borderWidth = 1
        
        self.logoImageView.backgroundColor = .white
        
        let logoURL = URL(string: self.project.logoURL)!
        self.logoImageView.af_setImage(withURL: logoURL)
        
        if let name = self.project?.projectName {
            self.projectNameLabel.text = name
        }
        
    }

    @IBAction func handleDeleteButtonTapped(_ sender: AnyObject) {
        self.delegate.delete(self.project)
    }
    
    class func instanceFromNib() -> AddedProjectButtonView {
        return UINib(nibName: "AddedProjectButtonView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddedProjectButtonView
    }
}
