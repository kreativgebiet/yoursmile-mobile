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
    @IBOutlet weak var rightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.rightImageView.image = #imageLiteral(resourceName: "close-icon")
        self.rightLabel.text = "1212"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
