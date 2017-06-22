//
//  FeedSimpleCollectionViewCell.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class FeedSimpleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    var callback: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(gesture:)))
        self.backgroundImageView.addGestureRecognizer(tap)
        
        self.backgroundImageView.clipsToBounds = true
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        if let response = self.callback {
            response()
        }
    }
}
