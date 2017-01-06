//
//  UploadUserImageOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 05.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class UploadUserImageOperation: NetworkOperation {
    
    public var callback: ((_ success: Bool, _ errorMessage: String) -> ())
    var image: UIImage!
    var username: String!
    
    init(_ image: UIImage,_ username: String, _ callback: @escaping (_ success: Bool, _ errorMessage: String) -> ()) {
        self.callback = callback
        self.image = image
        self.username = username
    }
    
    override func start() {
        super.start()
        APIClient.uploadUser(image: self.image, username: self.username) { (success, errorString) in
            self.callback(success, errorString)
            self.isFinished = true
        }
    }

}
