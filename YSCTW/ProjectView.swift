//
//  ProjectView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 14.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectView: UIView {
    
    var project: Project?
    var callback: ((_ project: Project) -> Void)?

    @IBOutlet var view: UIView!
    @IBOutlet weak var projectLogoImageView: RoundImageView!
    @IBOutlet weak var projectLabel: UILabel!
    
    init(project: Project, frame: CGRect) {
        super.init(frame: frame)
        self.project = project
        
        view = self.loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.projectLogoImageView.backgroundColor = .white
        self.projectLogoImageView.clipsToBounds = true
        
        self.projectLabel.textColor = .white
        self.projectLabel.backgroundColor = .clear
        
        self.projectLabel.text = self.project?.projectName
        
        if (self.project?.logoURL.count)! > 0 {
            let logoURL = URL(string: (self.project?.logoURL)!)!
            self.projectLogoImageView.af_setImage(withURL: logoURL)
        }
        
    }
    
    @objc func handleTap() {
        if (self.callback != nil) {
            self.callback!(self.project!)
        }
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
}
