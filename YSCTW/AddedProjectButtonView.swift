//
//  ProjectButtonView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 10.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

protocol AddedProjectButtonDelegate {
    func delete(_ project: Project)
    func sliderValueChanged(_ project: Project, _ value: Float)
}

class AddedProjectButtonView: UIView {
    public var delegate: AddedProjectButtonDelegate!
    public var project: Project!
    
    @IBOutlet weak var slider: DonationSlider!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    let sliderLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
        
        self.layer.borderColor = customDarkerGray.cgColor
        self.layer.borderWidth = 1
        
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height/2
        self.logoImageView.clipsToBounds = true
        self.logoImageView.layer.borderColor = gray223.cgColor
        self.logoImageView.layer.borderWidth = 1
        
        self.logoImageView.backgroundColor = .white
        
        let logoURL = URL(string: self.project.logoURL)!
        self.logoImageView.af_setImage(withURL: logoURL)
        
        if let name = self.project?.projectName {
            self.projectNameLabel.text = name
        }
        
        sliderLabel.font = UIFont(name: "Gotham-Bold", size: 16)
        sliderLabel.textColor = orange
        
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.setValue(slider.value, animated: false)
        
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        
        if sliderLabel.superview == nil {
            self.addSubview(sliderLabel)
        }
        
        sliderLabel.text = "\(Int(slider.value))€"
        sliderLabel.sizeToFit()
        sliderLabel.center = CGPoint(x: slider.thumbCenterX, y: slider.frame.maxY + sliderLabel.frame.height/2-10)
    }
    
    func sliderValueChanged(sender: UISlider) {
        sender.setValue(round(sender.value), animated: false)
        let value = sender.value
        
        sliderLabel.text = "\(Int(value))€"
        sliderLabel.sizeToFit()
        
        sliderLabel.center = CGPoint(x: slider.thumbCenterX, y: slider.frame.maxY + sliderLabel.frame.height/2-10)
        self.delegate.sliderValueChanged(self.project, slider.value)
    }

    @IBAction func handleDeleteButtonTapped(_ sender: AnyObject) {
        self.delegate.delete(self.project)
    }
    
    class func instanceFromNib() -> AddedProjectButtonView {
        return UINib(nibName: "AddedProjectButtonView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddedProjectButtonView
    }
}
