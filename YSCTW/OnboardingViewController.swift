//
//  OnboardingViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 24.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: RoundedButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var view1: OnboardPageView!
    var view2: OnboardPageView!
    var view3: OnboardPageView!
    var view4: OnboardPageView!
    
    var pageWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skipButton.backgroundColor = blue
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        self.scrollView.isScrollEnabled = true
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.pageControl.numberOfPages = 4
        self.pageControl.tintColor = orange
        self.pageControl.pageIndicatorTintColor = customDarkerGray
        self.pageControl.currentPageIndicatorTintColor = orange
        
        self.pageWidth = self.scrollView.frame.width
        
        var frame = CGRect(x: 0, y: 0, width: self.pageWidth, height: self.scrollView.frame.height)
        view1 = OnboardPageView(frame: frame)
        view1.topLabel.text = "ONBOARDING_TITEL_1".localized
        view1.bottomLabelText = "ONBOARDING_TEXT_1".localized
        
        frame.origin.x = self.pageWidth
        view2 = OnboardPageView(frame: frame)
        view2.topLabel.text = "ONBOARDING_TITEL_2".localized
        view2.bottomLabelText = "ONBOARDING_TEXT_2".localized
        
        frame.origin.x = self.pageWidth*2
        view3 = OnboardPageView(frame: frame)
        view3.topLabel.text = "ONBOARDING_TITEL_3".localized
        view3.bottomLabelText = "ONBOARDING_TEXT_3".localized
        
        frame.origin.x = self.pageWidth*3
        view4 = OnboardPageView(frame: frame)
        view4.topLabel.text = "ONBOARDING_TITEL_4".localized
        view4.bottomLabelText = "ONBOARDING_TEXT_4".localized
        
        self.scrollView.addSubview(view1)
        self.scrollView.addSubview(view2)
        self.scrollView.addSubview(view3)
        self.scrollView.addSubview(view4)
        
        self.scrollView.contentSize = CGSize(width: self.pageWidth*4, height: self.scrollView.frame.height)
        
        self.backgroundImageView.image = #imageLiteral(resourceName: "Image-onboarding1")
                
        self.skipButton.backgroundColor = blue
        self.skipButton.setTitleColor(.white, for: .normal)
        self.skipButton.setTitleColor(.white, for: .selected)
        
        self.skipButton.setTitle("PROCEED".localized, for: .normal)
        self.skipButton.setTitle("PROCEED".localized, for: .selected)
        self.skipButton.titleLabel?.font = UIFont(name: "Gotham-Book", size: 18)
        
        self.backgroundImageView.isUserInteractionEnabled = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeGesture.direction = .left
        self.backgroundImageView.addGestureRecognizer(swipeGesture)
    }
    
    func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if self.pageControl.currentPage < 3 {
                let xOffset = CGFloat(self.pageControl.currentPage + 1) * self.pageWidth
                self.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
                self.updatePage()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = CGSize(width: self.pageWidth * 3, height: self.scrollView.frame.height)
    }
    
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        self.proceedToLogin()
    }
    
    func proceedToLogin() {
        UserDefaults.standard.setValue(true, forKey: "didOnboarding")
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    // MARK: ScrollView Delegates
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let pageNumber = xOffset/self.pageWidth
        self.pageControl.currentPage = Int(pageNumber)
        self.updatePage()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.handleScrollingFor(scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.handleScrollingFor(scrollView)
    }
    
    // MARK: handle scrolling events
    
    func handleScrollingFor(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        
        if contentOffset > (self.pageWidth * CGFloat(self.pageControl.currentPage + 1))/2 {
            let xOffset = CGFloat(self.pageControl.currentPage + 1) * self.pageWidth
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        } else {
            let xOffset = CGFloat(self.pageControl.currentPage) * self.pageWidth
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        }
    }
    
    func updatePage() {
        switch self.pageControl.currentPage {
        case 1:
            self.backgroundImageView.image = #imageLiteral(resourceName: "Image-onboarding2")
        case 2:
            self.backgroundImageView.image = #imageLiteral(resourceName: "Image-onboarding3")
        case 3:
            self.backgroundImageView.image = #imageLiteral(resourceName: "Image-onboarding4")
            self.skipButton.setTitle("START".localized, for: .normal)
            self.skipButton.setTitle("START".localized, for: .selected)
        default:
            self.backgroundImageView.image = #imageLiteral(resourceName: "Image-onboarding1")
        }
    }
    
    @IBAction func handleSkipButtonTapped(_ sender: Any) {
        if self.pageControl.currentPage == 3 {
            self.proceedToLogin()
        } else {
            let xOffset = CGFloat(self.pageControl.currentPage + 1) * self.pageWidth
            self.scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            self.updatePage()
        }
    }

}
