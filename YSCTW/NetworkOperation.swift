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
    
    let date = Date()
    let formatter = DateFormatter()
    
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
                
                debugPrint(String(describing: self) + " finished at " + formatter.string(from: Date()))
            }
        }
    }
    
    override func start() {
        formatter.dateFormat = "mm.SSS"
        
        debugPrint(String(describing: self) + " started at " + formatter.string(from: Date()))
    }

}
