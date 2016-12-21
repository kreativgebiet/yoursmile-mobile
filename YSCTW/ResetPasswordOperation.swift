//
//  ResetPasswordOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ResetPasswordOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    var password: String!
    
    init(_ password: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
        self.password = password
    }
    
    override func start() {
        super.start()
        APIClient.resetPassword(newPassword: self.password) { (success, error) in
            self.callback(success, error)
            self.isFinished = true
        }
    }

}
