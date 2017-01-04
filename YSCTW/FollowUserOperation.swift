//
//  FollowUserOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 03.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class FollowUserOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    var userId: String!
    
    init(_ userId: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
        self.userId = userId
    }
    
    override func start() {
        super.start()
        APIClient.followUserWith(id: self.userId, callback: { (success, errorString) in
            self.callback(success, errorString)
            self.isFinished = true
        })
    }
    
}
