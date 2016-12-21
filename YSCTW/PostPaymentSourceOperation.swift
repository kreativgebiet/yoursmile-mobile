//
//  PostPaymentSourceOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class PostPaymentSourceOperation: NetworkOperation {
    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    var tokenId: String!
    
    init(_ tokenId: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        self.callback = callback
        self.tokenId = tokenId
    }
    
    override func start() {
        super.start()
        APIClient.postPaymentSource(self.tokenId) { (success, error) in
            self.callback(success, error)
            self.isFinished = true
        }
    }
}
