//
//  ImageCropNavigationController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 18.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ImageCropNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = navigationBarGray
        self.navigationBar.isTranslucent = false
        self.navigationBar.backgroundColor = navigationBarGray
        self.navigationBar.tintColor = .white
        
        self.toolbar.tintColor = .white
        self.toolbar.barTintColor = navigationBarGray
        self.toolbar.backgroundColor = navigationBarGray
        
        let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont(name: "Gotham-Book", size: 18)!, NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
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
