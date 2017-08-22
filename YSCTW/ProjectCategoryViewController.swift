//
//  ProjectCategoryViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 16.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ProjectCategoryViewController: UIViewController {
    
    var dataManager: DataManager? = nil
    var popToViewController: UIViewController? = nil
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var button1: CategoryButton!
    @IBOutlet weak var button2: CategoryButton!
    @IBOutlet weak var button3: CategoryButton!
    @IBOutlet weak var button4: CategoryButton!
    
    let buttonTitle = ["EDUCATION".localized, "HEALTH".localized, "NUTRITION".localized, "EMERGENCY".localized]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DONATE".localized
        
        button1.setTitle(buttonTitle[0], for: .normal)
        button2.setTitle(buttonTitle[1], for: .normal)
        button3.setTitle(buttonTitle[2], for: .normal)
        button4.setTitle(buttonTitle[3], for: .normal)
        
        topLabel.font = UIFont(name: "Zufo-Regular", size: 38)
        topLabel.textColor = blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if popToViewController != nil {
            self.navigationController?.navigationBar.isHidden = false
        } else {
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    @IBAction func handleButton1Tap(_ sender: Any) {
        pushProjectsViewController()
    }
    
    @IBAction func handleButton2Tap(_ sender: Any) {
        pushProjectsViewController()
    }
    
    @IBAction func handleButton3Tap(_ sender: Any) {
        pushProjectsViewController()
    }
    
    @IBAction func handleButton4Tap(_ sender: Any) {
        pushProjectsViewController()
    }
    
    func pushProjectsViewController() {
        
        let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        dataManager?.projects({ (projects) in
            
            loadingScreen.removeFromSuperview()
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectsViewController") as! ProjectsViewController
            viewController.projects = projects
            
            viewController.supportCallback = { selectedSupportProject in
                
                guard let navController = self.navigationController as? NavigationViewController else {
                    return
                }
                
                navController.supportedProjects.append(selectedSupportProject)
                
                if let viewController = self.popToViewController {
                    navController.popToViewController(viewController, animated: true)
                } else {
                    navController.performSegue(withIdentifier: "selfieSelectionSegue",     sender: selectedSupportProject)
                }
            }
            
            viewController.title = "PROJECTS".localized
            
            viewController.view.setNeedsLayout()
            viewController.view.layoutIfNeeded()
                        
            self.navigationController?.pushViewController(viewController, animated: true)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
