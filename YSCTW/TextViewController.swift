//
//  TextViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class TextViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    public var text: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = text        
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
