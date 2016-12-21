//
//  CommentDownloadOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class CommentDownloadOperation: NetworkOperation {
    
    public var callback: ((_ comments: [Comment]) -> () )
    var uploadId: String!
    
    init(_ uploadId: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        self.callback = callback
        self.uploadId = uploadId
    }
    
    override func start() {
        super.start()
        APIClient.commentsWith(self.uploadId) { (comments) in
            self.callback(comments)
            self.isFinished = true
        }
    }

}
