//
//  CountrListManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 20.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountrListManager: NSObject {
    
    var countryList = JSON.null
    
    override init() {
        
        let ressoureName = "countrylist_iso_3166"
        let type = "json"
        
        if let path = Bundle.main.path(forResource: ressoureName, ofType: type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSON(data: data)
                if jsonObj != JSON.null {
                    self.countryList = jsonObj
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
    
    public func countryNameFor(code: String) -> String {
        
        guard self.countryList != JSON.null else {
            return code
        }
        
        let countrys = self.countryList.arrayValue.filter({ (item) -> Bool in
            return item["fields"]["iso_2"].string! as String == code
        })
        
        guard countrys.count == 1 else {
            return code
        }
        
        let country = countrys[0]
        let selectedLanguage = LanguageManager.sharedInstance.getSelectedLocale()
        
        var selector = "name_en"
        
        switch selectedLanguage {
        case "de":
            selector = "name_de"
            break
            
        default:
            selector = "name_en"
        }
        
        guard let name = country["fields"][selector].string else {
            return code
        }
        
        return name as String
    }
 
}
