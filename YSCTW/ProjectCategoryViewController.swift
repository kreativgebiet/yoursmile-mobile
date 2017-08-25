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
    @IBOutlet weak var button5: CategoryButton!
    
    let buttonTitle = ["EDUCATION".localized, "HEALTH".localized, "NUTRITION".localized, "EMERGENCY".localized,"ALL".localized]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DONATE".localized
        
        button1.setTitle(buttonTitle[0], for: .normal)
        button1.sector = Sector.education
        button2.setTitle(buttonTitle[1], for: .normal)
        button2.sector = Sector.health
        button3.setTitle(buttonTitle[2], for: .normal)
        button3.sector = Sector.nutrition
        button4.setTitle(buttonTitle[3], for: .normal)
        button4.sector = Sector.emergency
        button5.setTitle(buttonTitle[4], for: .normal)
        button5.sector = Sector.all
        
        topLabel.font = UIFont(name: "Zufo-Regular", size: 38)
        topLabel.textColor = blue
    }
    
    func sectorFor(code: String) -> Sector {
        
        if code == "education" {
            return Sector.education
        } else if code == "nutrition" {
            return Sector.nutrition
        } else if code == "health" {
            return Sector.health
        } else if code == "emergency" {
            return Sector.emergency
        } else {
            return Sector.error
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if popToViewController != nil {
            self.navigationController?.navigationBar.isHidden = false
        } else {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        dataManager?.projects({ (projects) in
            loadingScreen.removeFromSuperview()
        })
    }
    
    @IBAction func handleButton1Tap(_ sender: CategoryButton) {
        pushProjectsViewController(sender)
    }
    
    @IBAction func handleButton2Tap(_ sender: CategoryButton) {
        pushProjectsViewController(sender)
    }
    
    @IBAction func handleButton3Tap(_ sender: CategoryButton) {
        pushProjectsViewController(sender)
    }
    
    @IBAction func handleButton4Tap(_ sender: CategoryButton) {
        pushProjectsViewController(sender)
    }
    
    @IBAction func handleButton5Tap(_ sender: CategoryButton) {
        pushProjectsViewController(sender)
    }
    
    
    func pushProjectsViewController(_ sender: CategoryButton) {
        
        let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        dataManager?.projects({ (projects) in
            
            
            loadingScreen.removeFromSuperview()
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectsViewController") as! ProjectsViewController
            viewController.projects = self.filter(projects, sender)
            
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
    
    func filter(_ projects: [Project], _ sender: CategoryButton) -> [Project] {
        
        let navController = self.navigationController as! NavigationViewController
        
        let tempProject = projects.filter({!navController.supportedProjects.contains($0)})
        
        switch sender.sector! {
        case .all:
            return tempProject
        case .education:
            return tempProject.filter({ (project) -> Bool in
                return project.sectorCode == "education"
            })
        case .nutrition:
            return tempProject.filter({ (project) -> Bool in
                return project.sectorCode == "nutrition"
            })
        case .health:
            return tempProject.filter({ (project) -> Bool in
                return project.sectorCode == "health"
            })
        case .emergency:
            return tempProject.filter({ (project) -> Bool in
                return project.sectorCode == "emergency"
            })
            
        default:
            return tempProject
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
