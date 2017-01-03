//
//  UserDataOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 03.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class UserDataOperation: NetworkOperation {
    
    public var callback: ((_ profile: Profile?) -> ())
    var userId: String!
    
    init(_ userId: String, _ callback: @escaping ((_ profile: Profile?) -> ())) {
        self.callback = callback
        self.userId = userId
    }
    
    override func start() {
        super.start()
        APIClient.userDataFor(id: self.userId, callback: { (_ profile: Profile?) in
            self.callback(profile)
            self.isFinished = true
        })
    }

}
