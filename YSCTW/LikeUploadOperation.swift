//
//  LikeUploadOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 08.05.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class LikeUploadOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorMessage: String) -> () )
    var uploadId: String?
    
    init(_ uploadId: String?, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
        self.uploadId = uploadId
    }
    
    override func start() {
        super.start()
        APIClient.likeUploadWith(id: self.uploadId, callback: { (success, errorString) in
            self.callback(success, errorString)
            self.isFinished = true
        })
    }

}
