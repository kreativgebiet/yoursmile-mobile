//
//  SectorListManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 20.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class SectorListManager: NSObject {
    
    let sector = [
        "edu" : "EDUCTION",
        "env" : "ENVIRONMENT",
        "food" : "FOOD",
        "health" : "HEALTH"
    ]
    
    public func sectorStringFor(code: String) -> String {
        guard let translation = sector[code]?.localized else {
            return code
        }
        
        return translation
    }
    
    
}
