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
                
        self.navigationBar.barTintColor = navigationBarGray
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = navigationBarGray

        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 18)!, NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.titleTextAttributes = attributes
        
        self.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back-icon")
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
            let donation = sender as! Upload
            destinationVC.donation = donation
        } else if segue.identifier == "cameraSegue" {
            let destination = segue.destination as! CameraViewController
            destination.dataManager = self.dataManager
            
            if let selectedProject = sender as? Project {
                destination.selectedProject = selectedProject
            } else if let profileVC = sender as? ProfileViewController {
                destination.customCallback = { image in
                    profileVC.profileImage = image
                    _ = self.popViewController(animated: true)
                }
            }
            
        } else if segue.identifier == "profileSegue" {
            let destination = segue.destination as! ProfileViewController
            let donation = sender as! Upload
            destination.dataManager = self.dataManager
            destination.currentProfile = donation.profile
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
