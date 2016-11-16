//
//  ProjectFilterViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectFilterViewController: UIViewController {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var spacerView: UIView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spacerView.backgroundColor = spacerGray
        self.leftView.backgroundColor = customLightGray
        self.rightView.backgroundColor = customLightGray
        
        self.leftLabel.backgroundColor = .clear
        self.rightLabel.backgroundColor = .clear
        self.view.backgroundColor = customLightGray
        
        //Localization
        self.leftLabel.text = "VISITED".localized
        self.rightLabel.text = "COUNTRY".localized
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
