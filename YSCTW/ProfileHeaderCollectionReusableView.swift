//
//  ProfileHeaderCollectionReusableView.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var leftTapView: UIView!
    @IBOutlet weak var rightTapView: UIView!
    
    @IBOutlet weak var gridImageView: UIImageView!
    @IBOutlet weak var gridLabel: UILabel!
    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var listLabel: UILabel!
    
    var notSelectedFont = UIFont(name: "Gotham-Medium", size: 16)
    var selectedFont = UIFont(name: "Gotham-Book", size: 16)
    
    var listSelectedCallback: (() -> ())?
    var gridSelectedCallback: (() -> ())?
    
    override func awakeFromNib() {
        self.backgroundColor = .white
        self.spacerView.backgroundColor = customGray
        
        self.rightTapView.backgroundColor = .clear
        self.leftTapView.backgroundColor = .clear
        
        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleListTap))
        self.leftTapView.addGestureRecognizer(leftTapGesture)
        
        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGridTap))
        self.rightTapView.addGestureRecognizer(rightTapGesture)
        
        selectList()
    }
    
    func selectGrid() {
        self.listLabel.font = notSelectedFont
        self.listLabel.textColor = navigationBarGray
        self.listImageView.image = #imageLiteral(resourceName: "listview-deselected")
        
        self.gridLabel.font = selectedFont
        self.gridLabel.textColor = orange
        self.gridImageView.image = #imageLiteral(resourceName: "gridview-selected")
    }
    
    func selectList() {
        self.listLabel.font = selectedFont
        self.listLabel.textColor = orange
        self.listImageView.image = #imageLiteral(resourceName: "listview-selected")
        
        self.gridLabel.font = notSelectedFont
        self.gridLabel.textColor = navigationBarGray
        self.gridImageView.image = #imageLiteral(resourceName: "gridview-deselected")
    }
    
    func handleListTap(_ sender : UITapGestureRecognizer) {
        selectList()
        if let callback = self.listSelectedCallback {
            callback()
        }
    }
    
    func handleGridTap(_ sender : UITapGestureRecognizer) {
        selectGrid()
        if let callback = self.gridSelectedCallback {
            callback()
        }
    }
        
}
