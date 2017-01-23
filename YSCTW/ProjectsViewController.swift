//
//  DonationProjectsViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    public var supportCallback: ((_ project: Project) -> Void)!
    
    var projectsTableViewController: ProjectsTableViewController!
    var filterViewController: ProjectFilterViewController!
    
    var picker: UIPickerView!
    var pickerDataLeft: [String]!
    var pickerDataRight: [String]!
    var leftPicker = false
    
    var projects = [Project]()
    var projectsToShow = [Project]()
    
    var leftSelectedIndex = 0
    var rightSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker = UIPickerView()
        self.picker.backgroundColor = customLightGray
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    public func reload() {
        
        self.pickerDataLeft = ["NO_FILTER_SELECTED".localized,"EDUCTION".localized,"ENVIRONMENT".localized,"FOOD".localized,"HEALTH".localized]
        self.pickerDataRight = ["NO_FILTER_SELECTED".localized]
        
        let countrys = self.projects.filter({$0.countryCode != nil}).filter({$0.country != ""}).map({ $0.country }) 
        self.pickerDataRight.append(contentsOf: countrys)
        
        self.picker.reloadAllComponents()
        
        self.projectsTableViewController.projects = self.projects
        self.projectsTableViewController.reload()
        
        self.projectsToShow = self.projects
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reload()
    }
    
    func togglePicker() {
        
        if self.picker.superview == nil {
            var frame = self.picker.frame as CGRect
            frame.size.width = self.view.frame.width
            frame.size.height = self.bottomContainerView.frame.height
            frame.origin.y = self.topContainerView.frame.maxY
            self.picker.frame = frame
            
            self.picker.reloadAllComponents()
            
            if self.leftPicker {
                self.picker.selectRow(self.leftSelectedIndex, inComponent: 0, animated: false)
            } else {
                self.picker.selectRow(self.rightSelectedIndex, inComponent: 0, animated: false)
            }
            
            self.view.addSubview(self.picker)
        } else {
            self.picker.removeFromSuperview()
        }
        
    }
    
    // MARK: - Delegates and data sources
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.togglePicker()
        
        if self.leftPicker {
            
            let selectedSector = self.pickerData()[row]
            self.filterViewController.leftLabel.text = selectedSector
            
            self.leftSelectedIndex = row
            
        } else {
            
            let selectedCountry = self.pickerData()[row]
            self.filterViewController.rightLabel.text = selectedCountry
            
            self.rightSelectedIndex = row
            
        }
        
        if self.leftSelectedIndex == 0 && self.rightSelectedIndex == 0 {
            self.projectsToShow = self.projects
        } else {
            
            if self.leftSelectedIndex == 0 {
                let country = self.pickerDataRight[self.rightSelectedIndex]
                self.projectsToShow = self.projects.filter({$0.country == country})
            } else if self.rightSelectedIndex == 0 {
                let sector = self.pickerDataLeft[self.leftSelectedIndex]
                self.projectsToShow = self.projects.filter({$0.sector == sector})
            } else {
                let country = self.pickerDataRight[self.rightSelectedIndex]
                let sector = self.pickerDataLeft[self.leftSelectedIndex]
                self.projectsToShow = self.projects.filter({$0.sector == sector}).filter({$0.country == country})
            }

        }
        
        self.projectsTableViewController.projects = self.projectsToShow
        self.projectsTableViewController.reload()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let titleData = self.pickerData()[row]
        let title = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Gotham-Book", size: 15),NSForegroundColorAttributeName:UIColor.white])
        
        return title.string
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if self.leftPicker {
            return pickerDataLeft.count
        } else {
            return pickerDataRight.count
        }
        
    }
    
    func pickerData() -> [String] {
        if self.leftPicker {
            return self.pickerDataLeft
        } else {
            return self.pickerDataRight
        }
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
            
        } else if segue.identifier == "projectsFilterSegue" {
            self.filterViewController = segue.destination as! ProjectFilterViewController
            
            self.filterViewController.countryCallback = {
                self.leftPicker = false
                self.togglePicker()
            }
            
            self.filterViewController.topicCallback = {
                self.leftPicker = true
                self.togglePicker()
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
