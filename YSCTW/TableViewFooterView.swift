//
//  TableViewFooterView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class TableViewFooterView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    public var selectionCallback: (() -> Void)?
    
    public var numberOfComments: Int {
        set(number) {
            self.textLabel.text = "ALL".localized + " " + String(number) + " " + "COMMENTS".localized
        }
        get {
            return 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        view = self.loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(view)
        
        view.backgroundColor = customLightGray
        self.textLabel.textColor = navigationBarGray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleTap() {
        self.selectionCallback!()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}
