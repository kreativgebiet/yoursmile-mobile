//
//  NavigationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    public var dataManager = DataManager()
    public var selectedPayment = Payment.none
    public var supportedProjects: [Project] = []
    public var selfieContext = SelfieContext.none
    public var selfie: UIImage? = nil
    public var sum: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white

        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Zufo-Regular", size: 28)!, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): blue]
        self.navigationBar.titleTextAttributes = attributes
        
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-icon").withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3.5, 0))
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-icon").withAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3.5, 0))
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationBar.tintColor = blue
        let rootViewController = self.viewControllers[0] as! ProjectCategoryViewController
        rootViewController.dataManager = self.dataManager
        
        self.delegate = self
    }
    
    func handleBackButtonTapped() {
        self.popViewController(animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cameraSegue" {
            let destination = segue.destination as! CameraViewController
            destination.dataManager = self.dataManager
            
            if let selectedProject = sender as? Project {
                destination.selectedProject = selectedProject
            }
            
        }
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}
