//
//  DonationDescriptionLogoView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDescriptionLogoView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var view: UIView!
    
    var projects: [Project]!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        UINib(nibName: "DonationDescriptionLogoView", bundle: nil).instantiate(withOwner: self, options: nil)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        self.backgroundColor = customLightGray
        self.view.backgroundColor = .clear
        self.scrollView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() })
        
        var x: CGFloat = 0.0
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        let contentView = UIView()
        
        for project in self.projects {
            let projectView = ProjectView.init(project: project, frame: CGRect(x: x, y: 0.0, width: width, height: height))
            
            projectView.setNeedsLayout()
            projectView.layoutIfNeeded()
            
            projectView.projectLabel.text = ""
            
            let projectViewWidth = projectView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width
            var frame = projectView.frame
            frame.size.width = projectViewWidth
            projectView.frame = frame
            
            contentView.addSubview(projectView)
            x += projectView.frame.size.width
        }
        
        contentView.frame = CGRect(x: 0, y: 0, width: x, height: height)
        
        if x < width {
            contentView.center = CGPoint(x: width/2, y: height/2)
        }
        
        self.scrollView.addSubview(contentView)
        self.scrollView.contentSize = CGSize(width: x, height: height)
    }
    

}
