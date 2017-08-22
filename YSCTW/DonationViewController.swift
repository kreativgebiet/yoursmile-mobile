//
//  DonationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import PhotoCropEditor

class DonationViewController: UIViewController, AddedProjectButtonDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var donationSumDescriptionLabel: UILabel!
    
    @IBOutlet weak var addProjectButton: AddProjectButton!
    @IBOutlet weak var projectContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paymentSelectionView: PaymentSelectionView!
    @IBOutlet weak var selectedProjectsContainerView: UIView!
    
    @IBOutlet weak var addProjectButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    public var dataManager: DataManager?
    public var selectedProject: Project?
    //Dictionary of kind [Project.id : float]
    public var selectedProjectDonations: [String : Float] = [:]
    
    var supportedProjects = [Project]()
    
    var selfieContext: SelfieContext?
    
    var navController: NavigationViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for project in supportedProjects {
            selectedProjectDonations[project.id] = 1
        }
        
        
        donationSumDescriptionLabel.text = "DONATION_SUM".localized
                
        self.paymentSelectionView.callback = { paymentType in
            let navigationView = self.navigationController?.view
            let overlay = DonationFeeOverlayView.init(frame: (navigationView?.bounds)!, numberOfProjects: self.supportedProjects.count, paymentType: paymentType)
            
            let view = UIView(frame: (navigationView?.bounds)!)
            view.backgroundColor = navigationBarGray.withAlphaComponent(0.6)
            view.alpha = 0
            navigationView?.addSubview(view)
            
            var frame = overlay.frame
            frame.origin.y = -frame.height
            overlay.frame = frame
            
            navigationView?.addSubview(overlay)
            
            UIView.animate(withDuration: 0.3, animations: {
                var frame = overlay.frame
                frame.origin.y = 0
                overlay.frame = frame
                
                view.alpha = 1
            })

            overlay.callback = {
                overlay.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        
        self.title = "DONATE".localized
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 100, height: 31)
        button.setTitle("PROCEED".localized, for: .normal)
        button.setTitle("PROCEED".localized, for: .selected)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(blue, for: .normal)
        button.setTitleColor(blue, for: .selected)
        button.titleLabel?.font = UIFont(name: "Gotham-Book", size: 18)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = blue
        
        self.navigationItem.rightBarButtonItem = barButton
        
        guard let navC = self.navigationController as? NavigationViewController else {
            return
        }
        
        navController = navC
        
        self.dataManager = navController.dataManager
        self.supportedProjects = navController.supportedProjects        
        
        if let project = self.selectedProject {
            self.supportedProjects.append(project)
            navController.supportedProjects.append(project)
        }
        
        self.addProjectButton.callback = {
            self.addProjectButtonTapped()
        }
        
        self.selectedProjectsContainerView.backgroundColor = .clear
        
        self.selectedProjectsContainerView.setNeedsLayout()
        self.selectedProjectsContainerView.layoutIfNeeded()
        
        showSum()
        self.loadSupportedProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        supportedProjects = navController.supportedProjects
        
        for project in supportedProjects {
            
            if !selectedProjectDonations.keys.contains(project.id) {
                selectedProjectDonations[project.id] = 1
            }
            
        }
        self.loadSupportedProjects()
        showSum()
    }
    
    func proceedTapped() {
        
        var error = ""
        
        if self.paymentSelectionView.selectedPayment == Payment.none {
            error = "PAYMENT_ERROR".localized + " "
        }
        
        if self.supportedProjects.count == 0 {
            error = error + "NO_PROJECT_ERROR".localized
        }
        
        if error.characters.count > 0 {
            
            HelperFunctions.presentAlertViewfor(error: error)
            
        } else {
            self.performSegue(withIdentifier: "donationDescriptionSegue", sender: self)
        }
        
    }
    
    func addProjectButtonTapped() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectCategoryViewController") as! ProjectCategoryViewController
        viewController.dataManager = self.navController.dataManager
        viewController.popToViewController = self
        
//        viewController.supportCallback = { selectedSupportProject in
//            self.supportedProjects.append(selectedSupportProject)
//            self.navController.supportedProjects.append(selectedSupportProject)
//
//            self.loadSupportedProjects()
//            
//            _ = self.navigationController?.popToViewController(self, animated: true)
//        }
//        
//        viewController.title = "PROJECTS".localized
//        
//        viewController.view.setNeedsLayout()
//        viewController.view.layoutIfNeeded()
//        
//        let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
//        self.view.addSubview(loadingScreen)
//        
//        self.dataManager?.projects({ (projects) in
////            loadingScreen.removeFromSuperview()
////            self.projects = projects
////            
////            viewController.projects = (self.projects.filter({!self.supportedProjects.contains($0)}))
////            viewController.reload()
//        })
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: ProjectView Creation
    
    var projectViews = [AddedProjectButtonView]()
    
    func loadSupportedProjects() {
        
        self.addProjectButton.textLabel.text = self.supportedProjects.count == 0 ? "SELECT_PROJECT".localized : "SELECT_ANOTHER_PROJECT".localized
        self.addProjectButton.textLabel.adjustsFontSizeToFitWidth = true
        
        for projectView in self.projectViews {
            projectView.removeFromSuperview()
        }
        
        self.projectViews.removeAll()
        
        var y: CGFloat = 0
        
        for (index, project) in self.supportedProjects.enumerated() {
            
            let projectView = AddedProjectButtonView.instanceFromNib()
            projectView.project = project
            projectView.delegate = self

            var frame = projectView.frame
            frame.size.width = self.selectedProjectsContainerView.frame.size.width
            frame.origin.y = y
            projectView.frame = frame
            
            projectView.setNeedsLayout()
            projectView.layoutIfNeeded()
            
            y += frame.size.height
            
            if index < self.supportedProjects.count-1 {
                y += 10.0
            }
            
            self.projectViews.append(projectView)
        }
        
        self.addProjectButtonTopConstraint.constant = y + 10
        
        y += self.addProjectButton.frame.height + 20
        
        self.projectContainerHeightConstraint.constant = y
        self.contentViewHeight.constant = y
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: y)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        for projectView in self.projectViews {
            self.selectedProjectsContainerView.addSubview(projectView)
        }
    }
    
    // MARK: - AddedProjectView delegate
    
    func delete(_ project: Project) {
        if let index = self.supportedProjects.index(of: project) {
            self.supportedProjects.remove(at: index)
        }
        
        self.loadSupportedProjects()
    }
    
    func sliderValueChanged(_ project: Project, _ value: Float) {
        print(project.projectName + " \(value)")
        selectedProjectDonations[project.id] = value
        showSum()
    }
    
    func showSum() {
        let sum = selectedProjectDonations.flatMap({Float($1)}).reduce(0, +)
        donationSumLabel.text = "\(Int(sum))€"
        navController.sum = sum
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue to DonationDescriptionViewController and CameraViewController
        guard let navController = self.navigationController as? NavigationViewController else {
            return
        }
        
        navController.supportedProjects = self.supportedProjects
        navController.selectedPayment = self.paymentSelectionView.selectedPayment
    }

}
