//
//  DonationProjectsViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {

    @IBOutlet weak var bottomContainerView: UIView!
    public var supportCallback: ((_ project: Project) -> Void)!
    
    var projectsTableViewController: ProjectsTableViewController!
    
    var projects = [Project]()
    var projectsToShow = [Project]()
    
    var leftSelectedIndex = 0
    var rightSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SELECT_PROJECT".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.reload()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    public func reload() {
        self.projectsTableViewController.projects = self.projects
        self.projectsTableViewController.reload()
        
        self.projectsToShow = self.projects
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "projectsTableViewSegue" {
            
            self.projectsToShow = self.projects
            
            self.projectsTableViewController = segue.destination as! ProjectsTableViewController
            self.projectsTableViewController.projects = self.projects
            self.projectsTableViewController.supportCallback = self.supportCallback
            
            self.projectsTableViewController.detailCallback = { project in
                self.performSegue(withIdentifier: "projectDetailSegue", sender: project)
            }
            
        } else if segue.identifier == "projectDetailSegue" || segue.identifier == "projectSegue" {
            
            let destination = segue.destination as! ProjectDetailViewController
            
            let project = sender as! Project
            
            destination.project = project
            
            destination.supportCallback = {
                self.supportCallback(project)
            }
            
        }
        
    }
    
}
