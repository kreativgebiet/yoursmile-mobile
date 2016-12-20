//
//  ErrorManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 20.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class ErrorManager: NSObject {
    
    class func handleRequest(_ response: HTTPURLResponse ) {
        
        switch response.statusCode {
        case 401:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: logoutNotificationIdentifier), object: nil)
            break
        default:
            break
        }
    }
    
}
