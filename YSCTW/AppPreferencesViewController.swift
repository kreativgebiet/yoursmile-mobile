//
//  AppPreferencesViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 11.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import MessageUI
import Down

class AppPreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [
        0 : [
            "title" : "ABOUT",
            "data" : ["ABOUT_YSCTW", "TERMS_CONDITIONS", "YOUR_FEEDBACK"]
        ],
        1 : [
            "title" : "APP_SETTINGS",
            "data" : ["CHANGE_LANGUAGE"]
        ],
        2 : [
            "title" : "INFORMATIONS",
            "data" : ["VERSION"]
        ]
    ] as [Int : [String:Any]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "PreferencesTableViewCell", bundle: nil), forCellReuseIdentifier: "PreferencesCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.sectionHeaderHeight = 40
        self.tableView.backgroundColor = customLightGray
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    // MARK: - TableView datasource and delegate

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let dict = self.data[section]
        let titleString = dict?["title"] as! String
        
        let y: CGFloat = (section == 0 ? 20 : 30)
        
        let title = UILabel()
        title.frame =  CGRect(x: 15,y: y,width: headerFrame.size.width-20,height: 20)
        title.font = UIFont(name: "Gotham-Bold", size: 12)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PreferencesCell", for: indexPath) as! PreferencesTableViewCell
        
        let dict = self.data[indexPath.section]
        let dictData = dict?["data"] as! [String]
        
        cell.mainLabel.text = dictData[indexPath.row].localized
        cell.selectionStyle = .none
        
        if dict?["title"] as! String != "INFORMATIONS" {
            cell.accessoryType = .disclosureIndicator
            cell.rightLabel.isHidden = true
        } else {
            cell.rightLabel.isHidden = false
            
            if let versionNumberString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                cell.rightLabel.text = versionNumberString
                cell.bringSubview(toFront: cell.rightLabel)
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //Version is not selectable
        if indexPath.section == 4 {
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            switch indexPath.row {
            case 0:
                
                //About
                let viewController = UIStoryboard(name: "Preferences", bundle: nil).instantiateViewController(withIdentifier: "TextViewController") as!  TextViewController
                
                let bundle = Bundle.main
                let path = bundle.path(forResource: "acknowledgments", ofType: "md")
                
                if let string = try? String(contentsOfFile: path!) {
                    let markdownString = Down(markdownString: string)
                    
                    do {
                        let html = try markdownString.toHTML()
                        let data = html.data(using: .utf8)
                        
                        let attrStr = try NSAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                        
                        viewController.attributedText = attrStr
                        
                    } catch _ {
                        print("Markdown File parsing error")
                    }
                    
                }
                
                viewController.title = "ABOUT_YSCTW".localized
                
                self.navigationController?.pushViewController(viewController, animated: true)
                
                break
            case 1:
                
                //Terms and conditions
                let viewController = UIStoryboard(name: "Preferences", bundle: nil).instantiateViewController(withIdentifier: "TextViewController") as!  TextViewController
                
                do {
                    let text = ""
                    let data = text.data(using: .utf8)
                    
                    let attrString = try NSAttributedString(data: data!, options: [:], documentAttributes: nil)
                    viewController.attributedText = attrString
                } catch _ {
                    print("parsing error")
                }
                
                
                viewController.title = "TERMS_CONDITIONS".localized
                
                self.navigationController?.pushViewController(viewController, animated: true)
                
                break
            case 2:
                
                //Terms and conditions
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    
                    //TODO get correct email
                    mail.setToRecipients(["support@mail.com"])
                    mail.setSubject("Support App")
                    mail.setMessageBody("<p>Send us your issue!</p>", isHTML: true)
                    self.present(mail, animated: true, completion: nil)
                } else {
                    HelperFunctions.presentAlertViewfor(error: "NO_MAIL".localized)
                }
                
                break
            default:
                break
                
            }
            
            
            break
        case 1:
            //Change language
            let selectedLanguage = LanguageManager.sharedInstance.getSelectedLocale()
            let availableLanguages = LanguageManager.sharedInstance.availableLocales
            
            let viewController = UIStoryboard(name: "Preferences", bundle: nil).instantiateViewController(withIdentifier: "LanguageSelectionViewController") as!  LanguageSelectionViewController
            
            viewController.selectedLanguage = selectedLanguage
            viewController.availableLanguages = availableLanguages
            viewController.title = "CHANGE_LANGUAGE".localized
            
            self.navigationController?.pushViewController(viewController, animated: true)

            break
            
        default:
            break
            
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
