//
//  AccountPreferencesViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 11.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class AccountPreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    public var profile:Profile?

    @IBOutlet weak var tableView: UITableView!
    
    var data = [
        0 : [
            "title" : "DISPLAY_NAME",
            "data" : [""]
        ],
        1 : [
            "title" : "ACCOUNT_SETTINGS",
            "data" : ["CHANGE_PASSWORD", "CHANGE_MAIL", "DELETE_ACCOUNT"]
        ],
        2 : [
            "title" : "PAYMENT_OPTIONS",
            "data" : ["PAYMENT_PAYPAL", "PAYMENT_CREDIT_CARD"]
        ]
    ] as [Int : [String:Any]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.sectionHeaderHeight = 40
        self.tableView.backgroundColor = customLightGray
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StandardCell")
    }
    
    // MARK: - TableView datasource and delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let dict = self.data[section]
        let titleString = dict?["title"] as! String
        
        let y: CGFloat = (section == 0 ? 20 : 30)
        
        let title = UILabel()
        title.frame =  CGRect(x: 15,y: y,width: headerFrame.size.width-20,height: 20)
        title.font = title.font.withSize(14)
        title.text = titleString.localized
        title.textColor = customMiddleGray
        
        let headerView:UIView = UIView(frame: CGRect(x: 0,y: 0,width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = customLightGray
        
        headerView.addSubview(title)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dict = self.data[section]
        
        return (dict!["data"]! as AnyObject).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath)
        
        let dict = self.data[indexPath.section]
        let dictData = dict?["data"] as! [String]
        
        cell.textLabel?.text = dictData[indexPath.row].localized
        cell.textLabel?.textColor = navigationBarGray
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if dict?["title"] as! String != "DISPLAY_NAME" {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = self.profile?.userName
        }
        
        return cell
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
