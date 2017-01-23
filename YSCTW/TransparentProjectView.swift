//
//  TransparentProjectView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class TransparentProjectView: UIView {
    
    var projects = [Project]()
    var callback: ((_ project: Project) -> Void)?
    
    @IBOutlet weak var projectsScrollView: UIScrollView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet var view: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        UINib(nibName: "TransparentProjectView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        
        self.projectsScrollView.backgroundColor = .clear
        self.transparentView.backgroundColor = navigationBarGray.withAlphaComponent(0.6)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        self.projectsScrollView.subviews.forEach({ $0.removeFromSuperview() })
        
        var x: CGFloat = 0.0
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        for project in self.projects {
            let projectView = ProjectView.init(project: project, frame: CGRect(x: x, y: 0.0, width: width, height: height))
            
            projectView.setNeedsLayout()
            projectView.layoutIfNeeded()
            
            let projectViewWidth = projectView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).width
            var frame = projectView.frame
            frame.size.width = projectViewWidth
            projectView.frame = frame
            
            self.projectsScrollView.addSubview(projectView)
            x += projectView.frame.size.width
            
            projectView.callback = { project in
                if self.callback != nil {
                    self.callback!(project)
                }
            }
        }
        
        self.projectsScrollView.contentSize = CGSize(width: x, height: height)
        
    }
    
}
