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
    public var sum: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.navigationBar.barTintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = .white
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true        
        self.navigationBar.backgroundColor = .clear

        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Zufo-Regular", size: 28)!, NSForegroundColorAttributeName: blue]
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
        
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
        
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
        } else if segue.identifier == "donationSegue" {
//            let destination = segue.destination as! DonationViewController
//            let selfieSelectionViewController = sender as! SelfieSelectionViewController
            
//            destination.selfieContext = selfieSelectionViewController.selfieContext
//            destination.supportedProjects.append(selfieSelectionViewController.project)
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
