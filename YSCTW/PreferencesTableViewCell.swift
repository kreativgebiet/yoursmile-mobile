//
//  PreferencesTableViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 18.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PreferencesTableViewCell: UITableViewCell {

    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainLabel.textColor = navigationBarGray
    
//        self.rightImageView.image = #imageLiteral(resourceName: "close-icon")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
