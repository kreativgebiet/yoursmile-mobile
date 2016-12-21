//
//  PreferencesViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {
    
    var profile: Profile?
    public var dataManager: DataManager!
    
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var appPreferencesViewController: AppPreferencesViewController!
    var accountPreferencesViewController: AccountPreferencesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profile = self.dataManager?.userProfile()
        
        self.spacerView.backgroundColor = customDarkerGray
        
        self.segmentedControl.tintColor = orange
        self.segmentedControl.backgroundColor = .white
        
        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 13)!]
        
        self.segmentedControl.setTitleTextAttributes(attributes, for: .normal)
        self.segmentedControl.setTitleTextAttributes(attributes, for: .selected)
        
        self.appPreferencesViewController = self.instantiateViewController(withIdentifier: "AppPreferencesViewController") as? AppPreferencesViewController
        self.appPreferencesViewController.view.backgroundColor = customLightGray
        
        self.addViewControllerAsChildViewController(viewController: self.appPreferencesViewController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentedControl.setTitle("YSCTW", forSegmentAt: 0)
        self.segmentedControl.setTitle("ACCOUNT_SETTINGS_SEGMENTED_TITLE".localized, forSegmentAt: 1)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.addViewControllerAsChildViewController(viewController: self.appPreferencesViewController)
                
            case 1:
                
                if self.accountPreferencesViewController == nil {
                    self.accountPreferencesViewController = self.instantiateViewController(withIdentifier: "AccountPreferencesViewController") as? AccountPreferencesViewController
                    
                    self.accountPreferencesViewController.profile = self.profile
                    self.accountPreferencesViewController.dataManager = self.dataManager
                }
                
                self.addViewControllerAsChildViewController(viewController: self.accountPreferencesViewController)
            
            default: (
                
            )
        }
    }

    private func addViewControllerAsChildViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        
        viewController.view.frame = self.containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeViewControllerAsChildViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    func instantiateViewController(withIdentifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }


}
