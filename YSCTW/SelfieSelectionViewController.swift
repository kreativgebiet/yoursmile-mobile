//
//  SelfieSelectionViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.08.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class SelfieSelectionViewController: UIViewController {
    
    @IBOutlet weak var withoutPhotoContainer: UIView!
    @IBOutlet weak var photoContainer: UIView!
    @IBOutlet weak var withoutPhotoLabel: UILabel!
    @IBOutlet weak var withPhotoLabel: UILabel!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var noPhotoImageView: UIImageView!
    
    var selfieContext = SelfieContext.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DONATE".localized
        
        withoutPhotoLabel.text = "WITHOUT_SELFIE".localized
        withPhotoLabel.text = "TAKE_SELFIE".localized
        
        withoutPhotoContainer.layer.cornerRadius = 4
        photoContainer.layer.cornerRadius = 4
        
        withoutPhotoContainer.layer.borderColor = gray221.cgColor
        photoContainer.layer.borderColor = gray221.cgColor
        
        withoutPhotoContainer.layer.borderWidth = 1
        photoContainer.layer.borderWidth = 1
        
        let selfieTap = UITapGestureRecognizer(target: self, action: #selector(handleSelfieTap(tapgesture:)))
        photoContainer.addGestureRecognizer(selfieTap)
        
        let noSelfieTap = UITapGestureRecognizer(target: self, action: #selector(handleNoSelfieTap(tapgesture:)))
        withoutPhotoContainer.addGestureRecognizer(noSelfieTap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    @objc func handleSelfieTap(tapgesture: UITapGestureRecognizer) {
        selfieContext = .withSelfie
        performSegue()
    }
    
    @objc func handleNoSelfieTap(tapgesture: UITapGestureRecognizer) {
        selfieContext = .noSelfie
        performSegue()
    }
    
    func performSegue() {
        
        guard let navController = self.navigationController as? NavigationViewController else {
            return
        }
        
        navController.selfieContext = selfieContext
        
        if selfieContext == .noSelfie {
            self.performSegue(withIdentifier: "donationSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "cameraSegue", sender: self)
        }
        
        
    }
    
}
