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
    class func findErrorsIn(_ json: Any) -> String {
        
        var errorMessage = ""
        
        if let dictionary = json as? [String: AnyObject] {
            if let status = dictionary["status"] {
                if  status as! String == "error" {
                    let errors = dictionary["errors"]?["full_messages"] as! [String]
                    errorMessage = errors.joined()
                }
            }
            
            if let errors = dictionary["errors"] as? [String]{
                
                errorMessage = (errorMessage.characters.count > 0 ? errorMessage + " " : errorMessage)
                errorMessage = errorMessage +  errors.joined()
            }
        }
        

        return errorMessage
    }
    
    class func parseResponseToJSON(data: Data) -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options:.allowFragments)
            return json
        } catch _ {
            return nil
        }
    }
    
    // MARK: Token Handling
    
    class func saveTokenFromResponse(response: HTTPURLResponse) {
        
        let token = response.allHeaderFields["Access-Token"] as? String
        let expiryDate = response.allHeaderFields["Expiry"] as? String
        let uid = response.allHeaderFields["Uid"] as? String
        let client = response.allHeaderFields["Client"] as? String
        
        if token != nil && expiryDate != nil && uid != nil && client != nil {
            let headerDict = [
                "access-token": token!,
                "token-type":   "Bearer",
                "client":       client!,
                "expiry":       expiryDate!,
                "uid":          uid!
            ]
                        
            do {
                try Locksmith.updateData(data: headerDict, forUserAccount: "myUserAccount")
            } catch _ {
                
            }
            
        }
    }
    
    class func verifyToken(callback: ((_ token: [String : String]) -> Void)!) {
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
        
        if let expiryTimeStamp = dictionary["expiry"] {
            let timeStamp = Double(expiryTimeStamp)
            let expiryDate = Date(timeIntervalSince1970: timeStamp!)
            
            if Date() < expiryDate {
               callback(dictionary)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: logoutNotificationIdentifier), object: nil)
            }

        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: logoutNotificationIdentifier), object: nil)
        }

    }
    
    class func deleteToken() {
        do {
            try Locksmith.deleteDataForUserAccount(userAccount: "myUserAccount")
        } catch _ {
            
        }
    }
    
    // MARK: Response handling
    
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
    
    // MARK: Projects Response handling
    
    class func parseProjectsFrom(response: Alamofire.DataResponse<Any>,callback: @escaping ((_ success: Bool, _ projects: [Project]) -> ())) {
        
        NetworkHelper.standardResponseHandling(response: response) { (success: Bool, error: String) in
            
            if success {
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [AnyObject]
                debugPrint("JSON: \(json)")
                
                var projects = [Project]()
                
                for dict in json {
                    
                    let description = dict["description"]
                    let name = dict["name"]
                    let logo = dict["logo"]
                    let id = dict["id"] as! Int
                    
                    debugPrint("JSON: \(json)")
                    
                    let project = Project(name: name as! String, description: description as! String, image: nil, logo: nil, id: String(id))
                    
                    projects.append(project)
                }
                
                callback(true, projects)
                
            } else {
                callback(false, [])
            }
            
        }
        
    }
    
}
