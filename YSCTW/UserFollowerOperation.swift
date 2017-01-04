//
//  UserFollowerOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 03.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class UserFollowerOperation: NetworkOperation {
    
    public var callback: ((_ profileRelations: [ProfileRelation]) -> ())
    var userId: String!
    
    init(_ userId: String, _ callback: @escaping ((_ profileRelations: [ProfileRelation]) -> ())) {
        self.callback = callback
        self.userId = userId
    }
    
    override func start() {
        super.start()
        APIClient.followerForUserWith(id: self.userId) { (profileRelations) in
            self.callback(profileRelations)
            self.isFinished = true
        }
    }

}
