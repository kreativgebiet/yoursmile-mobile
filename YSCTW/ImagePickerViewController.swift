//
//  ImagePickerViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 18.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ImagePickerViewController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.sourceType = .photoLibrary
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = navigationBarGray
        self.navigationBar.tintColor = .white
        let attributes: [String: Any] = [NSFontAttributeName: UIFont(name: "Gotham-Book", size: 18)!, NSForegroundColorAttributeName: UIColor.white]
        self.navigationBar.titleTextAttributes = attributes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
