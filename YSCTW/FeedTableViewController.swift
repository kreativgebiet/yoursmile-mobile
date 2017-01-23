//
//  FeedTableViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    public var selectedDonation: Upload?
    public var uploads: [Upload]?
    public var refreshCallback: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 467
        self.tableView.allowsSelection = false
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        
        self.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
    }
    
    func loadData() {
        self.refreshCallback()
    }
    
    public func reloadData() {
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return (self.uploads?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! FeedTableViewCell
        
        //Remove separator Insets
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        
        let donation = (self.uploads?[indexPath.row])! as Upload

        cell.donation = donation
        
        cell.detailCallback = { (donation: Upload) in
            self.navigationController?.performSegue(withIdentifier: "donationDetailSegue", sender: donation)
        }
        
        cell.profileCallback = { (donation: Upload) in
            self.navigationController?.performSegue(withIdentifier: "profileSegue", sender: donation)
        }

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
