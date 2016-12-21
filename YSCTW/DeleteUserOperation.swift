//
//  DeleteUserOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DeleteUserOperation: NetworkOperation {

    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    
    init(_ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
    }
    
    override func start() {
        super.start()
        APIClient.deleteUser { (success, error) in
            self.callback(success, error)
            self.isFinished = true
        }
    }
    
}
