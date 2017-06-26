//
//  NavigationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    let dataManager = DataManager()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationBar.barTintColor = orange
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = orange

        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 18)!, NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.titleTextAttributes = attributes
        
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-icon").withAlignmentRectInsets(UIEdgeInsetsMake(12, 0, 0, 0))
        self.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back-icon")
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationBar.tintColor = .white
        let rootViewController = self.viewControllers[0] as!TabBarViewController
        rootViewController.dataManager = self.dataManager
    }
    
    func handleBackButtonTapped() {
        self.popViewController(animated: true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "donationDetailSegue" {
            let destinationVC = segue.destination as! DonationDetailViewController
            
            let rootViewController = self.viewControllers[0] as!TabBarViewController
            //lazy implementation
            rootViewController.logoNavigationBarView.isHidden = false

            let donation = sender as! Upload
            destinationVC.dataManager = self.dataManager
            destinationVC.donation = donation
        } else if segue.identifier == "cameraSegue" {
            let destination = segue.destination as! CameraViewController
            destination.dataManager = self.dataManager
            
            if let selectedProject = sender as? Project {
                destination.selectedProject = selectedProject
            } else if let profileVC = sender as? ProfileViewController {
                destination.customCallback = { image in
                    profileVC.uploadUser(image: image)
                    _ = self.popViewController(animated: true)
                }
            }
            
        } else if segue.identifier == "profileSegue" {
            let destination = segue.destination as! ProfileViewController
            
            destination.dataManager = self.dataManager
            
            if let donation = sender as? Upload {
                destination.currentProfile = donation.profile
            } else if let profile = sender as? Profile {
                destination.currentProfile = profile
            }
            
            
        } else if segue.identifier == "projectSegue" {
            
            let rootViewController = self.viewControllers[0] as!TabBarViewController
            //lazy implementation
            rootViewController.logoNavigationBarView.isHidden = true
            
            let destination = segue.destination as! ProjectDetailViewController
            let project = sender as! Project
            
            destination.supportCallback = {
                self.performSegue(withIdentifier: "cameraSegue", sender: project)
            }
            
            destination.project = project
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
