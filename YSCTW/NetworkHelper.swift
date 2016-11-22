//
//  NetworkHelper.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

class NetworkHelper: NSObject {
    
    // MARK: Error handling
    class func findErrorsIn(_ json: [String:AnyObject]) -> String {
        
        var errorMessage = ""
        
        if let status = json["status"] {
            if  status as! String == "error" {
                let errors = json["errors"]?["full_messages"] as! [String]
                errorMessage = errors.joined()
            }
        }
        
        if let errors = json["errors"] as? [String]{
            
            errorMessage = (errorMessage.characters.count > 0 ? errorMessage + " " : errorMessage)
            errorMessage = errorMessage +  errors.joined()
        }
        
        return errorMessage
    }
    
    class func parseResponseToJSON(data: Data) -> [String:AnyObject]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments) as! [String:AnyObject]
            return json
        } catch _ {
            return nil
        }
    }
    
    // MARK: Token Handling
    
    class func saveTokenFromResponse(response: HTTPURLResponse) {
        
        let token = response.allHeaderFields["Access-Token"] as! String
        let expiryDate = response.allHeaderFields["Expiry"] as! String
        let uid = response.allHeaderFields["Uid"] as! String
        let client = response.allHeaderFields["Client"] as! String
        
        let headerDict = [
            "access-token": token,
            "token-type":   "Bearer",
            "client":       client,
            "expiry":       expiryDate,
            "uid":          uid
        ]
        
        do {
            try Locksmith.updateData(data: headerDict, forUserAccount: "myUserAccount")
        } catch _ {
            
        }
        
    }
    
    class func standardResponseHandling(response: Alamofire.DataResponse<Any>,callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        let json = NetworkHelper.parseResponseToJSON(data: response.data!)
        debugPrint("JSON: \(json)")
        
        if (json == nil) {
            callback(true, "ERROR".localized)
        } else {
            let errors = NetworkHelper.findErrorsIn(json!) as String
            
            if errors.characters.count > 0 {
                callback(false, errors)
            } else {
                NetworkHelper.saveTokenFromResponse(response: response.response!)
                callback(true, "")
            }
        }
    }
}
