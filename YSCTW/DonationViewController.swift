//
//  DonationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationViewController: UIViewController, AddedProjectButtonDelegate {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addProjectButton: AddProjectButton!
    
    @IBOutlet weak var projectsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var paymentSelectionView: PaymentSelectionView!
    @IBOutlet weak var selectedProjectsContainerView: UIView!
    
    public var selfieImage: UIImage?
    public var dataManager: DataManager?
    public var selectedProject: Project?
    
    var projects: [Project]?
    var supportedProjects = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projects = self.dataManager?.projects()
        
        self.title = "DONATE".localized
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 100, height: 31)
        button.setTitle("PROCEED".localized, for: .normal)
        button.setTitle("PROCEED".localized, for: .selected)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(orange, for: .normal)
        button.setTitleColor(orange, for: .selected)
        button.titleLabel?.font = UIFont(name: "Gotham-Book", size: 18)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
        
        self.descriptionLabel.text = "DONATION_DESCRIPTION".localized
        
        if let project = self.selectedProject {
            self.supportedProjects.append(project)
        }
        
        self.addProjectButton.callback = {
            self.addProjectButtonTapped()
        }

        self.selfieImageView.image = self.selfieImage
        self.selectedProjectsContainerView.backgroundColor = .clear
        
        self.selectedProjectsContainerView.setNeedsLayout()
        self.selectedProjectsContainerView.layoutIfNeeded()
        
        self.loadSupportedProjects()
    }
    
    // MARK: Button Handling
    
    func proceedTapped() {
        
        var error = ""
        
        if self.paymentSelectionView.selectedPayment == Payment.none {
            error = "PAYMENT_ERROR".localized + " "
        }
        
        if self.supportedProjects.count == 0 {
            error = error + "NO_PROJECT_ERROR".localized
        }
        
        if error.characters.count > 0 {
            
            let alertController = UIAlertController(title: "ERROR".localized, message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
                print("OK")
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            self.performSegue(withIdentifier: "donationDescriptionSegue", sender: self)
        }
        
    }
    
    func addProjectButtonTapped() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectsViewController") as! ProjectsViewController
        viewController.projects = self.projects?.filter({!self.supportedProjects.contains($0)})
        
        viewController.supportCallback = { selectedSupportProject in
            self.supportedProjects.append(selectedSupportProject)
            self.loadSupportedProjects()
            
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        viewController.title = "PROJECTS".localized
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: ProjectView Creation
    
    var projectViews = [AddedProjectButtonView]()
    
    func loadSupportedProjects() {
        
        self.addProjectButton.textLabel.text = self.supportedProjects.count == 0 ? "SELECT_PROJECT".localized : "SELECT_ANOTHER_PROJECT".localized
        
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
        
        self.projectsContainerHeightConstraint.constant = y
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
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "donationDescriptionSegue" {
            let destination = segue.destination as! DonationDescriptionViewController
            destination.selfieImage = self.selfieImage
            destination.projects = self.supportedProjects
            destination.payment = self.paymentSelectionView.selectedPayment
        }
    }

}
