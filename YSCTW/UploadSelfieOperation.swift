//
//  UploadSelfiesOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class UploadSelfiesOperation: NetworkOperation {
    
    var uploadModel: UploadModel
    
    init(_ uploadModel: UploadModel) {
        self.uploadModel = uploadModel
    }
    
    override func start() {
        super.start()
        APIClient.uploadSelfie(model: self.uploadModel) { (success, errorString) in
            self.isFinished = true
        }
    }

}
