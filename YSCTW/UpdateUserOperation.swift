//
//  UpdateUserOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class UpdateUserOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    var email: String!
    
    init(_ email: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
        self.email = email
    }
    
    override func start() {
        super.start()
        APIClient.updateUser(email: self.email) { (success, error) in
            self.callback(success, error)
            self.isFinished = true
        }
    }
    
}
