//
//  ProjectsDownloadOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class ProjectsDownloadOperation: NetworkOperation {
    
    public var callback: ((_ projects: [Project]) -> () )
    
    init(callback: @escaping ((_ projects: [Project]) -> () ) ) {
        self.callback = callback
    }
    
    override func start() {
        super.start()
        APIClient.projects { (projects) in
            self.callback(projects)
            self.isFinished = true
        }
    }

}
