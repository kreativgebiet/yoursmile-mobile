//
//  DelayOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 06.01.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import UIKit

class DelayOperation: NetworkOperation {

    
    override func start() {
        super.start()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isFinished = true
        }
    }

}
