//
//  NetworkOperation.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class NetworkOperation: Operation {
    
    private var _finished: Bool = false
    
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
                
                debugPrint(String(describing: self) + " finished")
            }
        }
    }
    
    override func start() {
        debugPrint(String(describing: self) + " started")
    }

}
