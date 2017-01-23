//
//  PickerView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 23.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

class PickerView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectButton: UIButton!
    
    public var callback: ((_ selectedRow: Int) -> Void)!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UINib(nibName: "PickerView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.backgroundColor = customGray2
        
        self.selectButton.setTitle("SELECT".localized.uppercased(), for: .normal)
        self.selectButton.setTitle("SELECT".localized.uppercased(), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func handleSelectButtonTapped(_ sender: Any) {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.callback(row)
    }
    
}
