//
//  PostCommentOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PostCommentOperation: NetworkOperation {
    
    public var callback: ((_ comments: [Comment]) -> () )
    var uploadId: String!
    var text: String!
    
    init(_ uploadId: String, _ text: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        self.callback = callback
        self.uploadId = uploadId
        self.text = text
    }
    
    override func start() {
        super.start()
        APIClient.postCommentWith(self.uploadId, self.text) { (comments) in
            self.callback(comments)
            self.isFinished = true
        }
    }

}
