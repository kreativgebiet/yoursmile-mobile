//
//  DonationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import PhotoCropEditor

class DonationViewController: UIViewController, AddedProjectButtonDelegate, CropViewControllerDelegate {
    
    @IBOutlet weak var adjustImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addProjectButton: AddProjectButton!
    @IBOutlet weak var upperBlurView: UIVisualEffectView!
    @IBOutlet weak var lowerBlurView: UIVisualEffectView!
    
    @IBOutlet weak var projectsContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selfieImageView: UIImageView!
    @IBOutlet weak var paymentSelectionView: PaymentSelectionView!
    @IBOutlet weak var selectedProjectsContainerView: UIView!
    @IBOutlet weak var selfieImageViewHeightConstraint: NSLayoutConstraint!
    
    public var selfieImage: UIImage?
    public var dataManager: DataManager?
    public var selectedProject: Project?
    
    var projects: [Project]?
    var supportedProjects = [Project]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projects = self.dataManager?.projects()
        
        self.paymentSelectionView.callback = {
            let navigationView = self.navigationController?.view
            let overlay = DonationFeeOverlayView(frame: (navigationView?.bounds)!)
            navigationView?.addSubview(overlay)

            overlay.callback = {
            overlay.removeFromSuperview()
            }
        }
        
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

        self.applyImageToImageView()
        
        self.selectedProjectsContainerView.backgroundColor = .clear
        
        self.selectedProjectsContainerView.setNeedsLayout()
        self.selectedProjectsContainerView.layoutIfNeeded()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(adjustTapped))
        
        self.adjustImageView.isUserInteractionEnabled = true
        self.adjustImageView.addGestureRecognizer(tapGesture)
        
        self.loadSupportedProjects()
    }
    
    func applyImageToImageView() {
        self.selfieImageView.image = self.selfieImage
        let aspect = (self.selfieImage?.size.height)! / (self.selfieImage?.size.width)!
        
        self.selfieImageViewHeightConstraint.constant = aspect * self.view.frame.width
    }
    
    // MARK: Button Handling
    
    func adjustTapped() {
        
        let controller = CropViewController()
        
        controller.delegate = self
        controller.image = self.selfieImage
        
        let navController = ImageCropNavigationController(rootViewController: controller)
        
        self.present(navController, animated: true, completion: nil)
    }
    
    func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage) {
        controller.dismiss(animated: true, completion: nil)
        
        self.selfieImage = image
        self.applyImageToImageView()
    }
    
    public func cropViewController(_ controller: CropViewController, didFinishCroppingImage image: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
        controller.dismiss(animated: true, completion: nil)
        
        self.selfieImage = image
        self.applyImageToImageView()
    }
    
    public func cropViewControllerDidCancel(_ controller: CropViewController) {
        controller.dismiss(animated: true, completion: nil)
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
            
            HelperFunctions.presentAlertViewfor(error: error, presenter: self)
            
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
            
            _ = self.navigationController?.popToViewController(self, animated: true)
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
