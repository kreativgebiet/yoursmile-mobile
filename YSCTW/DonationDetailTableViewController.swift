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
    
    public var donation: Upload?
    public var comments: [Comment]?

    var maximumComments = 3
    var footerView: TableViewFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.donationHeaderView.donation = self.donation
        self.tableView.reloadData()
        
        self.applyTableViewStyle()
        self.sizeHeaderToFit()
        self.applyFooterStyle()
    }
    
    func reloadData() {
        self.applyFooterStyle()
        self.tableView.reloadData()
    }
    
    func applyFooterStyle() {
        if ((self.comments != nil) && (self.comments?.count)! > maximumComments) {
            self.footerView = TableViewFooterView(frame: CGRect(x: 0,y: 0,width: tableView.frame.size.width,height: 40))
            self.footerView?.numberOfComments = (self.comments?.count)!
            
            self.footerView?.selectionCallback = {
                self.tableView.tableFooterView = nil
                self.maximumComments = (self.comments?.count)!
                self.tableView.reloadData()
            }
            
            self.tableView.tableFooterView = self.footerView
        } else {
            self.tableView.tableFooterView = UIView()
        }
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
        
        if self.comments?.count != nil {
            numberOfRows = min((self.comments?.count)!, self.maximumComments)
        }
        
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        
        let comment = self.comments?[indexPath.row]
        
        if (comment?.profile.avatarUrl.characters.count)! > 0 {
            let imageURL = URL(string: (comment?.profile.avatarUrl)!)!
            cell.profileImageView.af_setImage(withURL: imageURL)
        } else {
            cell.profileImageView.image = #imageLiteral(resourceName: "user-icon")
        }
        
        cell.nameLabel.text = comment?.profile.name
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        
        let attrString = NSMutableAttributedString(string: (comment?.text)!)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        cell.commentLabel.attributedText = attrString
        
        return cell
    }
    
}
