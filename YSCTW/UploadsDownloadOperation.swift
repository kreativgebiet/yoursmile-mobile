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
    var userId: String?
    
    init(userId: String?, callback: @escaping ((_ uploads: [Upload]) -> () ) ) {
        self.userId = userId
        self.callback = callback
    }
    
    override func start() {
        super.start()
        APIClient.uploadsWith(id: self.userId, callback: { (uploads) in
            self.callback(uploads)
            self.isFinished = true
        })
    }

}
