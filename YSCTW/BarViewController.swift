//
//  BarViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

enum Type {
    case feed
    case donation
    case camera
    case profile
    case preferences
}

protocol BarViewDelegate {
    func didSelectButtonOf(type: Type)
}

class BarViewController: UIViewController {
    @IBOutlet weak var feedButton: UIButton!
    @IBOutlet weak var donationButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var preferencesButton: UIButton!
    
    public var delegate: BarViewDelegate?
    
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedButton = feedButton
        self.selectedButton?.isSelected = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleFeedButtonTapped(_ sender: UIButton) {
        
        if sender != self.selectedButton {
            sender.isSelected = true
            self.selectedButton?.isSelected = false
            self.selectedButton = sender
            
            self.delegate?.didSelectButtonOf(type: Type.feed)
        }
    }

    @IBAction func handleDonationProjectsButtonTapped(_ sender: UIButton) {
        
        if sender != self.selectedButton {

            sender.isSelected = true
            self.selectedButton?.isSelected = false
            self.selectedButton = sender
            
            self.delegate?.didSelectButtonOf(type: Type.donation)
        }
    }
    
    @IBAction func handleCameraButtonTapped(_ sender: UIButton) {
        if sender != self.selectedButton {

//            sender.isSelected = true
//            self.selectedButton?.isSelected = false
//            self.selectedButton = sender
            
            self.delegate?.didSelectButtonOf(type: Type.camera)
        }
    }
    
    @IBAction func handleProfileButtonTapped(_ sender: UIButton) {
        if sender != self.selectedButton {

            sender.isSelected = true
            self.selectedButton?.isSelected = false
            self.selectedButton = sender
            
            self.delegate?.didSelectButtonOf(type: Type.profile)
        }
    }
    
    @IBAction func handlePreferencesButtonTapped(_ sender: UIButton) {
        if sender != self.selectedButton {

            sender.isSelected = true
            self.selectedButton?.isSelected = false
            self.selectedButton = sender
            
            self.delegate?.didSelectButtonOf(type: Type.preferences)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
