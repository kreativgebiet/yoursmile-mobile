//
//  ImageTableViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 23.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var roundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundImageView.layer.cornerRadius = self.roundImageView.frame.size.height/2
        self.roundImageView.clipsToBounds = true
        
        self.backgroundColor = customGray2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
