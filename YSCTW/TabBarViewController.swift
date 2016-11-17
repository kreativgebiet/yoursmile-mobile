//
//  TabBarViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, BarViewDelegate {
    
    @IBOutlet weak var childViewControllerContainerView: UIView!
    
    var currentChildViewController: UIViewController?
    var currentType = Type.feed
    
    var feedViewController: FeedViewController?
    var projectsViewController: ProjectsViewController?
    var cameraViewController: CameraViewController?
    var preferencesViewController: PreferencesViewController?
    var profileViewController: ProfileViewController?
    
    public var dataManager: DataManager?
    
    let logoNavigationBarView = LogoNavigationBarView(frame: CGRect(x: 0, y: 0, width: 102, height: 28))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoNavigationBarView.center = (self.navigationController?.navigationBar.center)!
        self.navigationController?.navigationBar.addSubview(self.logoNavigationBarView)
        
        self.feedViewController = self.viewControllerOf(type: .feed) as? FeedViewController
        self.feedViewController?.dataManager = self.dataManager
        
        self.addViewControllerAsChildViewController(viewController: self.feedViewController!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureNavigationBarFor(type: self.currentType)
    }
    
    private func addViewControllerAsChildViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        self.childViewControllerContainerView.addSubview(viewController.view)

        viewController.view.frame = self.childViewControllerContainerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
        
        self.currentChildViewController = viewController
    }
    
    private func removeViewControllerAsChildViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    // MARK: - VC Loading
    
    func viewControllerOf(type :Type) -> UIViewController {
        
        switch type {
            case .feed:
                if self.feedViewController == nil {
                    self.feedViewController = self.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController
                }
                
                            
                return self.feedViewController!
            case .donation:
                if self.projectsViewController == nil {
                    self.projectsViewController = self.instantiateViewController(withIdentifier: "ProjectsViewController") as? ProjectsViewController
                    self.projectsViewController?.projects = self.dataManager?.projects()
                    
                    self.projectsViewController?.supportCallback = { selectedProject in                        
                        self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: selectedProject)
                    }
                    
                }
            
                return self.projectsViewController!
            case .camera:
                if self.cameraViewController == nil {
                    self.cameraViewController = self.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController
                    
                }
            
                return self.cameraViewController!
            case .preferences:
                if self.preferencesViewController == nil {
                    self.preferencesViewController = self.instantiateViewController(withIdentifier: "PreferencesViewController") as? PreferencesViewController
                }
                
                self.preferencesViewController?.profile = self.dataManager?.profile()
            
                return self.preferencesViewController!
            case .profile:
                if self.profileViewController == nil {
                    self.profileViewController = self.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
                    self.profileViewController?.dataManager = self.dataManager
                }
                
                return self.profileViewController!
        }
        
    }
    
    func instantiateViewController(withIdentifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
    }
    
    func configureNavigationBarFor(type :Type) {
        
        switch type {
        case .feed:
            self.title = ""
            self.logoNavigationBarView.isHidden = false
            break
        case .donation:
            self.title = "PROJECTS".localized
            self.logoNavigationBarView.isHidden = true
        case .camera:
            self.logoNavigationBarView.isHidden = true
        case .preferences:
            self.title = "OPTIONS".localized
            self.logoNavigationBarView.isHidden = true
        case .profile:
            self.title = "PROFILE".localized
            self.logoNavigationBarView.isHidden = true
        }
    }
    
    // MARK: - Tabbar delegates
    
    func didSelectButtonOf(type: Type) {
        
        if type == self.currentType {
            return
        }
        
        self.configureNavigationBarFor(type: type)
        
        if type != Type.camera {
            self.currentType = type
            self.removeViewControllerAsChildViewController(viewController: self.currentChildViewController!)
            self.addViewControllerAsChildViewController(viewController: self.viewControllerOf(type: type))
        } else {
            self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: nil)
        }
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "barViewSegue" {
            let barViewController = segue.destination as! BarViewController
            barViewController.delegate = self
        }
        
    }
 

}
