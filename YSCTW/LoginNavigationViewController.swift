
//
//  LoginNavigationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class LoginNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.backgroundColor = .clear
        
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-icon").withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3.5, 0))
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-icon").withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3.5, 0))
        
        self.navigationBar.tintColor = blue

        self.navigationController?.navigationBar.barStyle = .black
        
        self.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    

}
