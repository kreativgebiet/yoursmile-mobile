//
//  UserFollowingOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 03.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class UserFollowingOperation: NetworkOperation {
    
    public var callback: ((_ profiles: [ProfileRelation]) -> ())
    var userId: String!
    
    init(_ userId: String, _ callback: @escaping ((_ profileRelations: [ProfileRelation]) -> ())) {
        self.callback = callback
        self.userId = userId
    }
    
    override func start() {
        super.start()
        APIClient.followingUsersForUserWith(id: self.userId) { (profiles) in
            self.callback(profiles)
            self.isFinished = true
        }
    }

}
