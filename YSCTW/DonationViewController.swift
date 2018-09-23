//
//  DonationViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
//import PhotoCropEditor

class DonationViewController: UIViewController, AddedProjectButtonDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var donationSumLabel: UILabel!
    @IBOutlet weak var donationSumDescriptionLabel: UILabel!
    
    @IBOutlet weak var addProjectButton: AddProjectButton!
    @IBOutlet weak var projectContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var paymentSelectionView: PaymentSelectionView!
    @IBOutlet weak var selectedProjectsContainerView: UIView!
    
    @IBOutlet weak var addProjectButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    public var dataManager: DataManager?
    public var selectedProject: Project?
    //Dictionary of kind [Project.id : float]
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencySelectionButton: UIButton!

    public var selectedProjectDonations: [String : Float] = [:]

    var selectedCurrency: Currency {
        if let currencyString = UserDefaults.standard.value(forKey: "selectedCurrency") as? String, let currency = Currency(rawValue: currencyString) {
            return currency
        }
        return .euro
    }
    
    var supportedProjects = [Project]()
    var selfieContext: SelfieContext?
    
    var navController: NavigationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(animateWithKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for project in supportedProjects {
            selectedProjectDonations[project.id] = 1
        }
        
        
        donationSumDescriptionLabel.text = "DONATION_SUM".localized
                
        self.paymentSelectionView.callback = { paymentType in
            let navigationView = self.navigationController?.view
            let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: self.sum(), paymentType: paymentType)
            let overlay = DonationFeeOverlayView.init(frame: (navigationView?.bounds)!, fee: fee, paymentType: paymentType, selectedCurrency: self.selectedCurrency)
            
            let view = UIView(frame: (navigationView?.bounds)!)
            view.backgroundColor = navigationBarGray.withAlphaComponent(0.6)
            view.alpha = 0
            navigationView?.addSubview(view)
            
            var frame = overlay.frame
            frame.origin.y = -frame.height
            overlay.frame = frame
            
            navigationView?.addSubview(overlay)
            
            UIView.animate(withDuration: 0.3, animations: {
                var frame = overlay.frame
                frame.origin.y = 0
                overlay.frame = frame
                
                view.alpha = 1
            })

            overlay.callback = {
                overlay.removeFromSuperview()
                view.removeFromSuperview()
            }
        }
        
        self.title = "DONATE".localized
        
        let button = UIButton()
        button.frame = CGRect(x: 0, y:  0, width: 100, height: 31)
        button.setTitle("PROCEED".localized, for: .normal)
        button.setTitle("PROCEED".localized, for: .selected)
        button.contentHorizontalAlignment = .right
        button.setTitleColor(blue, for: .normal)
        button.setTitleColor(blue, for: .selected)
        button.titleLabel?.font = UIFont(name: "Gotham-Book", size: 18)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(proceedTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        barButton.tintColor = blue
        
        self.navigationItem.rightBarButtonItem = barButton
        
        guard let navC = self.navigationController as? NavigationViewController else {
            return
        }
        
        navController = navC
        
        self.dataManager = navController.dataManager
        self.supportedProjects = navController.supportedProjects        
        
        if let project = self.selectedProject {
            self.supportedProjects.append(project)
            navController.supportedProjects.append(project)
        }
        
        self.addProjectButton.callback = {
            self.addProjectButtonTapped()
        }
        
        self.selectedProjectsContainerView.backgroundColor = .clear
        
        self.selectedProjectsContainerView.setNeedsLayout()
        self.selectedProjectsContainerView.layoutIfNeeded()

        self.currencySelectionButton.setTitle("CURRENCY".localized, for: .normal)
        self.currencySelectionButton.setTitle("CURRENCY".localized, for: .selected)
        self.currencySelectionButton.layer.cornerRadius = 5
        self.currencySelectionButton.clipsToBounds = true

        self.currencySelectionButton.layer.borderColor = customDarkerGray.cgColor
        self.currencySelectionButton.layer.borderWidth = 1
        
        showSum()
        self.loadSupportedProjects()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        supportedProjects = navController.supportedProjects
        
        for project in supportedProjects {
            
            if !selectedProjectDonations.keys.contains(project.id) {
                selectedProjectDonations[project.id] = 1
            }
            
        }
        self.loadSupportedProjects()
        showSum()
    }
    
    @objc func proceedTapped() {
        
        var error = ""
        
        if self.paymentSelectionView.selectedPayment == Payment.none {
            error = "PAYMENT_ERROR".localized + " "
        }
        
        if self.supportedProjects.count == 0 {
            error = error + "NO_PROJECT_ERROR".localized
        }
        
        if error.count > 0 {
            
            HelperFunctions.presentAlertViewfor(error: error)
            
        } else {
            proceedPayment()
        }
        
    }
    
    func addProjectButtonTapped() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ProjectCategoryViewController") as! ProjectCategoryViewController
        viewController.dataManager = self.navController.dataManager
        viewController.popToViewController = self
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: ProjectView Creation
    
    func proceedPayment() {

        let callback: ((_ uploadModel: UploadModel?, _ success: Bool, _ error: String) -> ()) = { (uploadModel, success, error) in

            if success {
                let projectIds = self.navController.supportedProjects.map({Int($0.id)!})

                var projectAmounts = [String: Int]()

                for (projectId, value) in self.selectedProjectDonations {
                    
                    let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: value, paymentType: self.paymentSelectionView.selectedPayment)

                    if self.paymentSelectionView.selectedPayment == .creditCard {
                        // Stride payments add the fee internally
                        let total = value * 100
                        projectAmounts[projectId] = Int(total)
                    } else {
                        let total = value * 100 + fee
                        projectAmounts[projectId] = Int(total)
                    }
                }
                uploadModel?.projectIds = projectIds.reversed()
                uploadModel?.projectAmounts = projectAmounts.map { $1 }

                do {
                    try uploadModel?.managedObjectContext?.save()
                } catch {
                    fatalError("Failure to save context: \(error)")
                }

                self.handleDonationSuccess()
            }

        }

        if self.paymentSelectionView.selectedPayment == .payPal {

            let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: self.sum(), paymentType: self.paymentSelectionView.selectedPayment)

            let paymentViewController = PayPalViewController()
            paymentViewController.selectedCurrency = selectedCurrency
            paymentViewController.callback = callback

            self.navigationController?.present(paymentViewController, animated: false, completion: nil)
            paymentViewController.showPayPalPaymentFor(amount: self.sum(),fee: fee, projects: self.navController.supportedProjects, paymentDict: selectedProjectDonations)

        } else if self.paymentSelectionView.selectedPayment == .creditCard {

            let fee = FeeCalculator.calculateFeeForPaymentAmount(amount: self.sum(), paymentType: self.paymentSelectionView.selectedPayment)

            let total = Int(fee*100) + Int(self.sum() * 100)

            let paymentViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController

            paymentViewController.callback = callback
            paymentViewController.totalPrice = total
            paymentViewController.selectedCurrency = selectedCurrency
            paymentViewController.dataManager = self.dataManager
            paymentViewController.title = "PAY".localized

            self.navigationController?.pushViewController(paymentViewController, animated: true)

        } else {
            print("ERROR")
        }

    }

    func uploadSelfie() {
        self.dataManager?.uploadSelfies()
    }

    func handleDonationSuccess() {

        self.uploadSelfie()

        self.view.endEditing(true)

        let navigationView = self.navigationController?.view
        let overlay2 = DonationSuccessOverlay(frame: (navigationView?.bounds)!)
        navigationView?.addSubview(overlay2)

        overlay2.callback = {
            overlay2.removeFromSuperview()
            self.performSegue(withIdentifier: "donationDescriptionSegue", sender: self)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: feedNotificationIdentifier), object: nil)
        }
    }

    // MARK: ProjectView Creation
    
    var projectViews = [AddedProjectButtonView]()
    
    func loadSupportedProjects() {
        
        self.addProjectButton.textLabel.text = self.supportedProjects.count == 0 ? "SELECT_PROJECT".localized : "SELECT_ANOTHER_PROJECT".localized
        self.addProjectButton.textLabel.adjustsFontSizeToFitWidth = true
        
        for projectView in self.projectViews {
            projectView.removeFromSuperview()
        }
        
        self.projectViews.removeAll()
        
        var y: CGFloat = 0
        
        for (index, project) in self.supportedProjects.enumerated() {
            
            let projectView = AddedProjectButtonView.instanceFromNib()
            projectView.project = project
            projectView.delegate = self

            var frame = projectView.frame
            frame.size.width = self.selectedProjectsContainerView.frame.size.width
            frame.origin.y = y
            
            var height: CGFloat = 133
            
            if let value = selectedProjectDonations[project.id] {
                
                projectView.setNeedsLayout()
                projectView.layoutIfNeeded()
                
                projectView.slider.setValue(round(value), animated: false)
                projectView.setNeedsLayout()
                projectView.layoutIfNeeded()
                projectView.sliderLabel.text = "\(Int(value)) \(selectedCurrency.symbol)"
                projectView.sliderLabel.sizeToFit()
                projectView.sliderLabel.center = CGPoint(x: projectView.slider.thumbCenterX, y: projectView.slider.frame.maxY + projectView.sliderLabel.frame.height/2)
                
                
                if (value >= Float(sliderMaxValue) && projectView.project.id == project.id) {
                    
                    if value > Float(sliderMaxValue) {
                        height = 166
                        projectView.sliderLabel.isHidden = true
                        projectView.individualDonationTextfieldTopConstraint.constant = 5
                        projectView.individualDonationTextfield.text = String(format: "%.0f", value)
                    } else {
                        height = 197
                        projectView.sliderLabel.isHidden = false
                        projectView.individualDonationTextfieldTopConstraint.constant = 32
                        projectView.individualDonationTextfield.text = ""
                    }
                    
                } else {
                    projectView.individualDonationTextfield.text = ""
                }
                
            }
            
            projectView.containerViewHeightConstraint.constant = height
            frame.size.height = height
            projectView.frame = frame
            
            y += height
            
            if index < self.supportedProjects.count-1 {
                y += 10.0
            }
            
            self.projectViews.append(projectView)
        }
        
        self.addProjectButtonTopConstraint.constant = y + 10
        
        y += self.addProjectButton.frame.height + 20
        
        self.projectContainerHeightConstraint.constant = y
        self.contentViewHeight.constant = y
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: y)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        for projectView in self.projectViews {
            self.selectedProjectsContainerView.addSubview(projectView)
        }
        
        showSum()
    }

    private func updateLabels() {
        loadSupportedProjects()
    }
    
    // MARK: - AddedProjectView delegate
    
    func delete(_ project: Project) {
        if let index = self.navController.supportedProjects.index(of: project) {
            self.navController.supportedProjects.remove(at: index)
        }
        
        if let index = self.supportedProjects.index(of: project) {
            self.supportedProjects.remove(at: index)
        }
        
        self.selectedProjectDonations.removeValue(forKey: project.id)
        
        self.loadSupportedProjects()
    }
    
    func sliderValueChanged(_ project: Project, _ value: Float) {
        
        selectedProjectDonations[project.id] = value
        
        var y: CGFloat = 0
        
        var index = 0
        
        for projectView in self.projectViews {
            
            guard let donationValue = selectedProjectDonations[projectView.project.id] else {
                return
            }
            
            var frame = projectView.frame
            frame.size.width = self.selectedProjectsContainerView.frame.size.width
            frame.origin.y = y
            
            var height: CGFloat = 133
            
            if (donationValue >= Float(sliderMaxValue)) {
                
                if donationValue > Float(sliderMaxValue) {
                    height = 166
                    projectView.sliderLabel.isHidden = true
                    projectView.individualDonationTextfieldTopConstraint.constant = 5
                } else {
                    height = 197
                    projectView.sliderLabel.isHidden = false
                    projectView.individualDonationTextfieldTopConstraint.constant = 32
                }
                
            } else {
                projectView.individualDonationTextfield.text = ""
            }
            
            projectView.containerViewHeightConstraint.constant = height
            frame.size.height = height
            projectView.frame = frame
            
            y += height
            
            if index < self.supportedProjects.count-1 {
                y += 10.0
            }
            
            index += 1
            
            projectView.setNeedsLayout()
            projectView.layoutIfNeeded()
        
        }
        
        self.addProjectButtonTopConstraint.constant = y + 10
        y += self.addProjectButton.frame.height + 20
        
        self.projectContainerHeightConstraint.constant = y + self.addProjectButton.frame.height
        self.contentViewHeight.constant = y
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: y)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        showSum()
    }
    
    func sum() -> Float {
        let sum = selectedProjectDonations.compactMap({Float($1)}).reduce(0, +)
        return sum
    }
    
    func showSum() {
        donationSumLabel.text = "\(Int(sum())) \(selectedCurrency.symbol)"
        navController.sum = sum()
    }

    // MARK: - Keyboard

    @IBAction func handleCurrencySelectionButton(_ sender: Any) {

        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self

        self.view.addSubview(picker)

        let alertView = UIAlertController(title: "SELECT_CURRENCY".localized, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertView.view.addSubview(picker)

        alertView.view.topAnchor.constraint(equalTo: picker.topAnchor).isActive = true
        alertView.view.leadingAnchor.constraint(equalTo: picker.leadingAnchor).isActive = true
        alertView.view.trailingAnchor.constraint(equalTo: picker.trailingAnchor).isActive = true

        alertView.view.heightAnchor.constraint(equalToConstant: 250).isActive = true

        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)

        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    // MARK: - Keyboard
    
    @objc func animateWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let moveUp = (notification.name == NSNotification.Name.UIKeyboardWillShow)

        var keyboardHeight: CGFloat = 0
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardRectangle = keyboardFrame.cgRectValue
            keyboardRectangle = self.view .convert(keyboardRectangle, from: nil)
            
            keyboardHeight = keyboardRectangle.height
        }
        
        self.scrollViewBottomConstraint.constant = moveUp ? keyboardHeight-(self.view.frame.height-donationSumLabel.frame.origin.y) : 15
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options,
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil
        )
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue to DonationDescriptionViewController and CameraViewController
        guard let navController = self.navigationController as? NavigationViewController else {
            return
        }
        
        navController.supportedProjects = self.supportedProjects
        navController.selectedPayment = self.paymentSelectionView.selectedPayment
    }

}

extension DonationViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    static let selectableCurrencies: [Currency] = [.euro, .chf, .dollar, .pound]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DonationViewController.selectableCurrencies.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = DonationViewController.selectableCurrencies[row]
        return currency.rawValue
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = DonationViewController.selectableCurrencies[row]
        UserDefaults.standard.setValue(currency.rawValue, forKey: "selectedCurrency")
        UserDefaults.standard.synchronize()
        updateLabels()
    }
}
