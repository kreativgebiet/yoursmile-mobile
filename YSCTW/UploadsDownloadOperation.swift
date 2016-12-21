//
//  UploadsDownloadOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class UploadsDownloadOperation: NetworkOperation {
    
    public var callback: ((_ uploads: [Upload]) -> () )
    
    init(callback: @escaping ((_ uploads: [Upload]) -> () ) ) {
        self.callback = callback
    }
    
    override func start() {
        super.start()
        APIClient.uploads { (uploads) in
            self.callback(uploads)
            self.isFinished = true
        }
    }

}
