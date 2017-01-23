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
    var preferencesBarButtonItem: UIBarButtonItem!
    var barViewController: BarViewController!
    
    let logoNavigationBarView = LogoNavigationBarView(frame: CGRect(x: 0, y: 0, width: 102, height: 28))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 170, height: 28))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ""
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 51, height: 31)
        button.setImage(#imageLiteral(resourceName: "preferences-icon"), for: .normal)
        button.transform = CGAffineTransform(translationX: 15, y: 0)
        button.addTarget(self, action: #selector(preferencesTapped), for: .touchUpInside)
        
        let containerView = UIView()
        containerView.frame = button.frame
        containerView.addSubview(button)
        
        self.preferencesBarButtonItem = UIBarButtonItem()
        self.preferencesBarButtonItem.customView = containerView
        self.preferencesBarButtonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = self.preferencesBarButtonItem
        
        self.logoNavigationBarView.center = (self.navigationController?.navigationBar.center)!
        self.navigationController?.navigationBar.addSubview(self.logoNavigationBarView)
        
        self.titleLabel.font = UIFont(name: "Gotham-Book", size: 18)
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textColor = .white
        self.titleLabel.textAlignment = .center
        
        self.titleLabel.center = (self.navigationController?.navigationBar.center)!
        self.navigationController?.navigationBar.addSubview(self.titleLabel)
        
        self.titleLabel.isHidden = true
        
        self.feedViewController = self.viewControllerOf(type: .feed) as? FeedViewController
        self.feedViewController?.dataManager = self.dataManager
        
        self.addViewControllerAsChildViewController(viewController: self.feedViewController!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openFeed), name: NSNotification.Name(rawValue: feedNotificationIdentifier), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(preferencesTapped), name: NSNotification.Name(rawValue: preferencesNotificationIdentifier), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: NSNotification.Name(rawValue: logoutNotificationIdentifier), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func openFeed() {
        self.didSelectButtonOf(type: .feed)
        self.barViewController.selectButtonOf(type: .feed)
    }
    
    func preferencesTapped() {
        self.didSelectButtonOf(type: .preferences)
        self.barViewController.selectButtonOf(type: .preferences)
    }
    
    func logout() {
        UserDefaults.standard.setValue(false, forKey: "loggedIn")
        NetworkHelper.deleteToken()
        FBSDKLoginManager().logOut()
        CoreDataController().deleteProfileModel()
        HelperFunctions.presentAlertViewfor(error: "LOGOUT_ERROR".localized, {
          self.navigationController?.performSegue(withIdentifier: "logoutSegue", sender: self)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureNavigationBarFor(type: self.currentType)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.titleLabel.isHidden = true
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
                
                self.dataManager?.uploadsWith(nil, { (uploads) in
                    self.feedViewController?.uploads = uploads
                    self.feedViewController?.reload()
                })
                
                return self.feedViewController!
            case .donation:
                if self.projectsViewController == nil {
                    
                    self.projectsViewController = self.instantiateViewController(withIdentifier: "ProjectsViewController") as? ProjectsViewController
                    self.projectsViewController?.supportCallback = { selectedProject in
                        self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: selectedProject)
                    }
                    self.projectsViewController?.view.setNeedsLayout()
                    self.projectsViewController?.view.layoutIfNeeded()
                    
                    let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
                    self.view.addSubview(loadingScreen)
                    
                    self.dataManager?.projects({ (projects) in
                        
                        loadingScreen.removeFromSuperview()
                        self.projectsViewController?.projects = projects
                        self.projectsViewController?.reload()
                    })
                    
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
                
                self.preferencesViewController?.dataManager = self.dataManager
            
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
            self.titleLabel.isHidden = true
            self.logoNavigationBarView.isHidden = false
            self.navigationItem.rightBarButtonItem = self.preferencesBarButtonItem
            break
        case .donation:
            self.titleLabel.text = "PROJECTS".localized
            self.navigationItem.rightBarButtonItem = nil
            self.titleLabel.isHidden = false
            self.logoNavigationBarView.isHidden = true
        case .camera:
            self.titleLabel.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            self.logoNavigationBarView.isHidden = true
        case .preferences:
            self.titleLabel.text = "OPTIONS".localized
            self.navigationItem.rightBarButtonItem = nil
            self.titleLabel.isHidden = false
            self.logoNavigationBarView.isHidden = true
        case .profile:
            self.titleLabel.text = "PROFILE".localized
            self.navigationItem.rightBarButtonItem = nil
            self.titleLabel.isHidden = false
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
            self.barViewController = segue.destination as! BarViewController
            self.barViewController.delegate = self
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
