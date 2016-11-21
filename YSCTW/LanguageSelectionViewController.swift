//
//  LanguageSelectionViewController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class LanguageSelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    
    public var selectedLanguage: String!
    public var availableLanguages: [CustomLocale]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let selectedCustomLocale = self.availableLanguages.filter({$0.languageCode == self.selectedLanguage})[0]
        self.pickerView.selectRow(self.availableLanguages.index(of: selectedCustomLocale)!, inComponent: 0, animated: false)
    }

    // MARK: - Delegates and data sources
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let customLocale = self.availableLanguages[row]
        LanguageManager.sharedInstance.setLocale(customLocale.languageCode!)

        self.title = "CHANGE_LANGUAGE".localized
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let customLocale = self.availableLanguages[row]
        
        return customLocale.name
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableLanguages.count
    }

}
