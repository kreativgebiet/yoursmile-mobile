//
//  DonationDetailViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DonationDetailViewController: UIViewController {
    
    @IBOutlet weak var commentView: CommentView!
    @IBOutlet weak var commentViewBottomSpaceConstraint: NSLayoutConstraint!
    
    public var donation: Donation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 51, height: 31)
        button.setImage(#imageLiteral(resourceName: "more-icon"), for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationItem.rightBarButtonItem?.setBackgroundVerticalPositionAdjustment(10, for: UIBarMetrics.default)
                
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Bar button handling
    
    func addTapped() {
        let navigationView = self.navigationController?.view
        let overlay = DonationDetailOverlayView(frame: (navigationView?.bounds)!)
        navigationView?.addSubview(overlay)
    }

    // MARK: - Keyboard animations
    
    func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)        
        
        self.commentViewBottomSpaceConstraint.constant = moveUp ? (keyboardSize?.height)! : 0
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options,
                       animations: {
                        self.view.layoutIfNeeded()
            },
                       completion: nil
        )
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "donationDetailTableVCSegue" {
            let destination = segue.destination as! DonationDetailTableViewController
            destination.donation = self.donation
        }
        
    } 
}
