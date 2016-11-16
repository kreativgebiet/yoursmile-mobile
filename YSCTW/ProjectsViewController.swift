//
//  DonationProjectsViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController {
    //TODO remove and replace with projects directly to be able to filter....
    public var dataManager: DataManager?
    public var supportCallback: ((_ project: Project) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "projectsTableViewSegue" {
            let destinationVC = segue.destination as! ProjectsTableViewController
            destinationVC.projects = self.dataManager?.projects()
            destinationVC.supportCallback = self.supportCallback
        }
        
    }

}
