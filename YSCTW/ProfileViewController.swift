//
//  ProfileViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 07.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    public var dataManager: DataManager?
    public var currentProfile: Profile?
    public var userProfile = DataManager().userProfile()
    
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileViewHeightConstraint: NSLayoutConstraint!
    
    var initialProfileViewHeightConstraint: CGFloat!
    var donations: [Upload]?
    var profileToUse: Profile!
    var profileHeaderBarView: ProfileHeaderBarView!
    var follower: [ProfileRelation]?
    var followerIds: [Int]?
    
    let minimumProfileHeaderHeight = 215.0 as CGFloat
    
    var isListViewFlowLayoutSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileHeaderView.profile = self.currentProfile
        self.profileHeaderView.userProfile = self.userProfile
        self.profileHeaderView.layoutIfNeeded()
        
        self.profileHeaderBarView = ProfileHeaderBarView(frame: CGRect(x: 0, y: -60, width: self.view.frame.width, height: 60))
        self.profileHeaderBarView.profile = self.currentProfile
        self.profileHeaderBarView.userProfile = self.userProfile
        self.profileHeaderBarView.backgroundColor = customGray2
        
        self.profileHeaderBarView.backButtonCallback = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.profileToUse = ((self.currentProfile != nil) ? self.currentProfile : self.userProfile)!
        
        if self.currentProfile == nil {
            self.profileViewHeightConstraint.constant = minimumProfileHeaderHeight
        }
        
        self.initialProfileViewHeightConstraint = self.profileViewHeightConstraint.constant
        
        self.profileHeaderView.subscribeCallback = {
            let loadingScreen = LoadingScreen(frame: self.view.bounds)
            self.view.addSubview(loadingScreen)
            
            let id = (self.currentProfile?.id)! as Int!
            let idString = "\(id!)"
            self.dataManager?.followUserWith(id: idString, { (success, errorString) in
                loadingScreen.removeFromSuperview()
                
                if success {
                    self.profileHeaderView.hideSubscribeButton()
                    self.reloadUserData()
                    self.profileViewHeightConstraint.constant = self.minimumProfileHeaderHeight
                    self.initialProfileViewHeightConstraint = self.minimumProfileHeaderHeight
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
            })
        }
        
        self.profileHeaderView.backButtonCallback = {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        self.profileHeaderView.cameraCallback = {
            self.navigationController?.performSegue(withIdentifier: "cameraSegue", sender: self)
        }
        
        self.profileHeaderView.followerCallback = {
            let vc = FollowerViewController(nibName: "FollowerViewController", bundle: nil)
            vc.dataManager = self.dataManager
            self.navigationController?.pushViewController(vc, animated: true)
            
            vc.followerIds = self.followerIds!
        }
        
        self.profileHeaderView.followingCallback = {
            let vc = SupportedProjectsViewController(nibName: "SupportedProjectsViewController", bundle: nil)
            vc.dataManager = self.dataManager
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.applyCollectionViewStyle()
        self.reloadData()
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        self.view.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func applyCollectionViewStyle() {
        
        let listFlowLayout = UploadsListFlowLayout.init()
        listFlowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 55)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.setCollectionViewLayout(listFlowLayout, animated: true)
        
        self.collectionView.register(UINib(nibName: "FeedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.register(UINib(nibName: "FeedSimpleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SimpleCollectionViewCell")
        
        self.collectionView.register(UINib(nibName: "ProfileHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    }
    
    func reloadUserData() {
        self.dataManager?.userDataFor(id: self.idString(), { (profile) in            
            if self.currentProfile == nil {
                self.profileHeaderView.userProfile = profile
            } else {
                self.profileHeaderView.profile = profile
            }
            
            self.profileHeaderView.setNeedsLayout()
            self.profileHeaderView.layoutIfNeeded()
            
        })
    }
    
    func reloadData() {
        let loadingScreen = LoadingScreen(frame: (self.navigationController?.view)!.bounds)
        self.navigationController?.view.addSubview(loadingScreen)
        
        self.dataManager?.uploadsWith(self.idString(), { (uploads) in
            self.donations = uploads
            //Could be implemented instead of current implementation
            //            let supportedProjects = self.donations?.map({$0.projects})
            self.profileHeaderView.numberOfSupportedProjects = (self.donations?.count)!
            
            self.collectionView.reloadData()
        })
        
        self.reloadUserData()
        
        self.dataManager?.followerForUserWith(id: self.idString(), { (relationProfiles) in
            
            self.follower = relationProfiles
            
            loadingScreen.removeFromSuperview()
            self.followerIds = relationProfiles.map({$0.userId})
            
            if (self.followerIds?.contains(Int(self.userProfile.id)))! {
                self.profileHeaderView.hideSubscribeButton()
                self.profileViewHeightConstraint.constant = self.minimumProfileHeaderHeight
                self.initialProfileViewHeightConstraint = self.minimumProfileHeaderHeight
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            
        })
    }
    
    func idString() -> String {
        let id = self.profileToUse.id as Int!
        return "\(id!)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        self.collectionView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.profileHeaderView.setNeedsLayout()
        self.profileHeaderView.layoutIfNeeded()
        
        self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        self.collectionView.contentInset = UIEdgeInsets.zero
        
        self.profileViewHeightConstraint.constant = self.initialProfileViewHeightConstraint
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.profileHeaderBarView.frame = CGRect(x: 0, y: -60, width: self.view.frame.width, height: 60)
        
        self.reloadData()
    }
    
    // MARK: - Upload user profile image
    
    func uploadUser(image: UIImage) {
        let loadingScreen = LoadingScreen(frame: self.view.bounds)
        self.view.addSubview(loadingScreen)
        
        self.dataManager?.uploadUser(image: image, username: self.userProfile.name, { (success, errorString) in
            loadingScreen.removeFromSuperview()
        })
    }
    
    // MARK: - Header animation
    
    var animating = false
    var dragging = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dragging = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        dragging = false
        
        let profileViewHeight = self.profileViewHeightConstraint.constant

        print("didenddraggin dec: " + (decelerate ? "true" : "false"))

        if profileViewHeight > self.initialProfileViewHeightConstraint {
            self.profileViewHeightConstraint.constant = self.initialProfileViewHeightConstraint
            print("initial: " + String(describing: self.initialProfileViewHeightConstraint))

            UIView.animate(withDuration: 0.2, animations: {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                print("profileViewHeightConstraint: " + String(describing: self.profileViewHeightConstraint.constant))
            })
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentHeight = scrollView.contentSize.height
        let profileHeaderHeight = self.profileHeaderBarView.frame.height

        if contentHeight == 0 || animating{
            return
        } else if self.profileViewHeightConstraint.constant < 30 {
            if self.profileHeaderBarView.superview == nil {
                self.animateProfileHeaderBarView(show: true, completion: { (completed) in
                    self.profileViewHeightConstraint.constant = profileHeaderHeight
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                })
                return
            }
        }
        
        let velocity = fabs(scrollView.panGestureRecognizer.velocity(in: self.view).y)
        let velocityLimit = 2000.0 as CGFloat
        
        if velocity > 0 {
            print(velocity)
        }
        
        if scrollView.contentOffset.y > 0 && self.profileViewHeightConstraint.constant > profileHeaderHeight && self.profileViewHeightConstraint.constant != 60 {
            var newConstant: CGFloat = self.profileViewHeightConstraint.constant - scrollView.contentOffset.y
            
            newConstant = (velocity > velocityLimit ? newConstant - velocity/50 : newConstant)
            self.profileViewHeightConstraint.constant = newConstant
            
            self.profileHeaderView.subscriptionView.alpha = newConstant/self.initialProfileViewHeightConstraint
            
            if velocity > velocityLimit {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                })
            } else {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            
            self.collectionView.setContentOffset(CGPoint.zero, animated: false)
        } else if scrollView.contentOffset.y < 0 && (dragging || self.profileViewHeightConstraint.constant < self.initialProfileViewHeightConstraint) {
            let newConstant: CGFloat = min(self.profileViewHeightConstraint.constant - scrollView.contentOffset.y, self.initialProfileViewHeightConstraint + 50)
            
            self.profileHeaderView.subscriptionView.alpha = newConstant/self.initialProfileViewHeightConstraint
            
            if velocity > velocityLimit+900 && self.profileViewHeightConstraint.constant < self.initialProfileViewHeightConstraint {
                self.profileViewHeightConstraint.constant = newConstant + velocity/20
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }, completion: { (completed) in
                    
                })
            } else {
                self.profileViewHeightConstraint.constant = newConstant
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
        
        if self.profileViewHeightConstraint.constant <= profileHeaderHeight && self.profileHeaderBarView.superview == nil {
            self.animateProfileHeaderBarView(show: true)
        } else if self.profileViewHeightConstraint.constant > profileHeaderHeight && self.profileHeaderBarView.superview != nil {
            self.animateProfileHeaderBarView(show: false)
        }
    }
    
    func animateProfileHeaderBarView(show: Bool, completion: ((Bool) -> Swift.Void)? = nil) {
        animating = true
        
        if show {
            self.view.addSubview(self.profileHeaderBarView)
            let profileHeaderHeight = self.profileHeaderBarView.frame.height

            self.profileViewHeightConstraint.constant = profileHeaderHeight
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.2, animations: {
                
                var frame = self.profileHeaderBarView.frame
                frame.origin.y = 0
                
                self.profileHeaderBarView.frame = frame
            }, completion: { (completed) in
                self.animating = false
                if completion != nil {
                    completion!(completed)
                }
            })
        } else {
            
            UIView.animate(withDuration: 0.2, animations: {
                var frame = self.profileHeaderBarView.frame
                frame.origin.y = -frame.height
                
                self.profileHeaderBarView.frame = frame
            }, completion: { (completed) in
                self.profileHeaderBarView.removeFromSuperview()
                self.animating = false
                if completion != nil {
                    completion!(completed)
                }
            })
        }
    }
    
    
    // MARK: - Collection view data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        
        if let projects = self.donations?.count {
            numberOfItems = projects
        }
        
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.isListViewFlowLayoutSelected {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! FeedCollectionViewCell
            
            let donation = (self.donations?[indexPath.row])! as Upload
            
            cell.donation = donation
            
            cell.detailCallback = { (donation: Upload) in
                self.navigationController?.performSegue(withIdentifier: "donationDetailSegue", sender: donation)
            }
            
            cell.profileCallback = { (donation: Upload) in
                self.navigationController?.performSegue(withIdentifier: "profileSegue", sender: donation)
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell;
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleCollectionViewCell", for: indexPath) as! FeedSimpleCollectionViewCell
            
            let donation = (self.donations?[indexPath.row])! as Upload
            cell.backgroundImageView.image = nil
            cell.backgroundImageView.clipsToBounds = true
            let imageURL = URL(string: donation.imageURL)!
            cell.backgroundImageView.af_setImage(withURL: imageURL)
            
            cell.callback = {
                self.navigationController?.performSegue(withIdentifier: "donationDetailSegue", sender: donation)
            }
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as! ProfileHeaderCollectionReusableView
        
        headerView.listSelectedCallback = {
            self.isListViewFlowLayoutSelected = true
            
            UIView.animate(withDuration: 0.2) { () -> Void in
                let listFlowLayout = UploadsListFlowLayout.init()
                listFlowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 55)
                
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(listFlowLayout, animated: true)
                self.collectionView.reloadData()
            }
            
        }
        
        headerView.gridSelectedCallback = {
            self.isListViewFlowLayoutSelected = false
            
            UIView.animate(withDuration: 0.2) { () -> Void in
                let gridFlowLayout = UploadsGridFlowLayout.init()
                gridFlowLayout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 55)
                
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(gridFlowLayout, animated: true)
                self.collectionView.reloadData()
            }
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width:collectionView.frame.size.width, height:55.0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
