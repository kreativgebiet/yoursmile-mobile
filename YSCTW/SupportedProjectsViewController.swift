//
//  SupportedProjectsViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 26.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class SupportedProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    public var dataManager: DataManager?
    var projects: [Project] = []
    
    let cellIdentifier = "ImageTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "SUPPORTED_PROJECTS".localized
        
        let subviews = self.navigationController?.navigationBar.subviews
        
        for subview in subviews! {
            if let bar = subview as? LogoNavigationBarView {
                bar.isHidden = true
            }
        }
        
        self.navigationItem.leftBarButtonItem
            = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(goback))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.backgroundColor = customGray2
        self.tableView.backgroundColor = customGray2
        self.tableView.separatorColor = customGray
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func goback() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let profile = self.follower[indexPath.row]
//        
//        self.navigationController?.performSegue(withIdentifier: "profileSegue", sender: profile)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ImageTableViewCell
//        let follower = self.follower[indexPath.row]
//        
//        cell.descriptionLabel?.text = follower.name
//        
//        cell.roundImageView.image = nil
//        
//        if follower.avatarUrl.characters.count > 0 {
//            let imageURL = URL(string: follower.avatarUrl)
//            cell.roundImageView.af_setImage(withURL: imageURL!)
//        } else {
//            cell.roundImageView.image = #imageLiteral(resourceName: "user-icon")
//        }
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }

}
