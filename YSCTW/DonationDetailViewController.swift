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
    
    public var donation: Upload?
    public var dataManager: DataManager?
    
    var donationDetailTableViewController: DonationDetailTableViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentView.callback = { text in
            let loadingScreen = LoadingScreen.init(frame: self.view.bounds)
            self.view.addSubview(loadingScreen)
            
            self.dataManager?.postCommentWith((self.donation?.id)!, text, { (comments) in
                self.donationDetailTableViewController.comments?.append(contentsOf: comments)
                self.donationDetailTableViewController.reloadData()
                self.commentView.commentTextField.text = ""
                self.commentView.endEditing(true)
                
                loadingScreen.removeFromSuperview()
            })
        }
        
        self.dataManager?.commentsWith((donation?.id)!, { (comments) in
            self.donationDetailTableViewController.comments = comments
            self.donationDetailTableViewController.reloadData()
        })
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 51, height: 31)
        button.setImage(#imageLiteral(resourceName: "more-icon"), for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        button.transform = CGAffineTransform(translationX: 15, y: 3)
        
        let containerView = UIView()
        containerView.frame = button.frame
        containerView.addSubview(button)
        
        let barButton = UIBarButtonItem()
        barButton.customView = containerView
        barButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationItem.rightBarButtonItem?.setBackgroundVerticalPositionAdjustment(10, for: UIBarMetrics.default)
                
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Bar button handling
    
    func addTapped() {
        self.view.endEditing(true)
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
            self.donationDetailTableViewController = segue.destination as! DonationDetailTableViewController
            self.donationDetailTableViewController.donation = self.donation
        }
        
    } 
}
