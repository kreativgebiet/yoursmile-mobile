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
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [String : AnyObject]
                debugPrint("JSON: \(json)")
                
                if let data = json["data"] as? [AnyObject] {
                    var projects = [Project]()
                    
                    for dict in data {
                        
                        let description = dict["description"] as! String
                        let name = dict["name"] as! String
                        let logoURL = dict["logo"] as! String
                        let imageURL = dict["image"] as! String
                        let progress = dict["progress"] as! Int
                        let id = dict["id"] as! Int
                        let countryCode = dict["country_code"] as! String
                        let sectorCode = dict["sector_code"] as! String
                        
                        debugPrint("JSON: \(json)")
                        
                        let project = Project(name: name, description: description, progress: progress, id: String(id), imageURL: imageURL, logoURL: logoURL, countryCode: countryCode, sectorCode: sectorCode)
                        
                        projects.append(project)
                    }
                    
                    callback(true, projects)
                } else {
                    callback(false, [])
                }
                
            } else {
                callback(false, [])
            }
            
        }
        
    }
    
    // MARK: Uploads Response handling

    class func parseUploadsFrom(response: Alamofire.DataResponse<Any>,callback: @escaping ((_ success: Bool, _ uploads: [Donation]) -> ())) {
        
        NetworkHelper.standardResponseHandling(response: response) { (success: Bool, error: String) in
            
            if success {
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [String : AnyObject]
                debugPrint("JSON: \(json)")
                
                if let data = json["data"] as? [AnyObject] {
                    var uploads = [Donation]()
                    
                    for dict in data {
                        
//                        let description = dict["description"] as! String
//                        let name = dict["name"] as! String
//                        let logoURL = dict["logo"] as! String
//                        let imageURL = dict["image"] as! String
//                        let progress = dict["progress"] as! Int
//                        let id = dict["id"] as! Int
//                        let countryCode = dict["country_code"] as! String
//                        let sectorCode = dict["sector_code"] as! String
//                        
//                        debugPrint("JSON: \(json)")
//                        
//                        let project = Project(name: name, description: description, progress: progress, id: String(id), imageURL: imageURL, logoURL: logoURL, countryCode: countryCode, sectorCode: sectorCode)
                        
//                        
//                        uploads.append(project)
                    }
                    
                    callback(true, uploads)
                } else {
                    callback(false, [])
                }
                
            } else {
                callback(false, [])
            }
            
        }
        
    }
}
