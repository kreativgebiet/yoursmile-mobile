//
//  ReportUploadOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 17.02.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class ReportUploadOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorString: String) -> ())
    
    var uploadId: Int!
    
    init(_ uploadId: Int, _ callback: @escaping (_ success: Bool, _ errorString: String) -> ()) {
        self.uploadId = uploadId
        self.callback = callback
    }
    
    override func start() {
        super.start()
        APIClient.reportUploadsWith(id: self.uploadId) { (success, errorString) in
            self.callback(success, errorString)
            self.isFinished = true
        }
    }

}
