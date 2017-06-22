//
//  UploadsGridFlowLayout.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class UploadsGridFlowLayout: UICollectionViewFlowLayout {
    
    let itemHeight: CGFloat = 125
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width/2)-1
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
