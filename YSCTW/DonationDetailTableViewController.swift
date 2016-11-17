//
//  DonationDetailTableViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDetailTableViewController: UITableViewController {

    @IBOutlet weak var donationHeaderView: DonationDetailHeaderView!
    
    public var donation: Donation?
    var maximumComments = 3
    var footerView: TableViewFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.donationHeaderView.donation = self.donation
        
        if ((self.donation?.comments != nil) && (self.donation?.comments?.count)! > maximumComments) {
            self.footerView = TableViewFooterView(frame: CGRect(x: 0,y: 0,width: tableView.frame.size.width,height: 40))
            self.footerView?.numberOfComments = (self.donation?.comments?.count)!
            
            self.footerView?.selectionCallback = {
                self.tableView.tableFooterView = nil
                self.maximumComments = (self.donation?.comments?.count)!
                self.tableView.reloadData()
            }
            
            self.tableView.tableFooterView = self.footerView
        } else {
            self.tableView.tableFooterView = UIView()
        }
        
        self.applyTableViewStyle()
        self.sizeHeaderToFit()
    }
    
    func applyTableViewStyle() {
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = customLightGray
    }
    
    func sizeHeaderToFit() {
        //Force Autolayout calculation of Header height
        let headerView = self.tableView.tableHeaderView!
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        
        self.tableView.tableHeaderView = headerView
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        
        if self.donation?.comments?.count != nil {
            numberOfRows = min((self.donation?.comments?.count)!, self.maximumComments)
        }
        
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = self.donation?.comments?[indexPath.row]
        
        cell.profileImageView.image = comment?.commentProfileImage
        cell.nameLabel.text = comment?.commentName
        cell.commentLabel.text = comment?.comment
        
        return cell
    }
    
}
