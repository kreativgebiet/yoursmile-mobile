//
//  ProjectsTableViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectsTableViewController: UITableViewController {
    
    public var supportCallback: ((_ project: Project) -> Void)!
    public var detailCallback: ((_ project: Project) -> Void)!
    
    public var projects: [Project]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTableViewStyle()
    }

    func applyTableViewStyle() {
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib(nibName: "ProjectTableViewCell", bundle: nil), forCellReuseIdentifier: "ProjectCell")
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = .white
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "PROJECTS".localized
        self.reload()
    }
    
    public func reload() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.projects?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath) as! ProjectTableViewCell
        
        let project = self.projects?[indexPath.row]
        cell.project = project
        
        cell.detailCallback = { project in
            self.detailCallback(project)
        }
        
        cell.supportCallback = { project in
            self.supportCallback(project)
        }

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
