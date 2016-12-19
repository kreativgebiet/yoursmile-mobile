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
            callback(false, "ERROR".localized)
        } else {
            let errors = NetworkHelper.findErrorsIn(json!) as String
            
            if errors.characters.count > 0 {
                callback(false, errors)
                //TODO
//                HelperFunctions.
            } else {
                NetworkHelper.saveTokenFromResponse(response: response.response!)
                callback(true, "")
            }
        }
    }
    
    class func uploadResponseHandling(response: Alamofire.DefaultDataResponse,callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        let json = NetworkHelper.parseResponseToJSON(data: response.data!)
        debugPrint("JSON: \(json)")
        
        if (json == nil) {
            callback(false, "ERROR".localized)
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
                  
                    let projects = NetworkHelper.parseProjectsFrom(data: data)
                    callback(true, projects)
                } else {
                    callback(false, [])
                }
                
            } else {
                callback(false, [])
            }
            
        }
        
    }
    
    class func parseProjectsFrom(data: [AnyObject]) -> [Project] {
        var projects = [Project]()
        
        for dict in data {
            
            let id = dict["id"] as! Int
            let name = dict["name"] as! String
            let logoURL = dict["logo"] as! String
            
            var description = ""
            if let desc = dict["description"] as? String {
                description = desc
            }
            
            var imageURL = ""
            if let desc = dict["image"] as? String {
                imageURL = desc
            }
            
            var progress = 0
            if let desc = dict["progress"] as? Int {
                progress = desc
            }
            
            var countryCode = ""
            if let desc = dict["country_code"] as? String {
                countryCode = desc
            }
            
            var sectorCode = ""
            if let desc = dict["sector_code"] as? String {
                sectorCode = desc
            }
            
            let project = Project(name: name, description: description, progress: progress, id: String(id), imageURL: imageURL, logoURL: logoURL, countryCode: countryCode, sectorCode: sectorCode)
            
            projects.append(project)
        }
        
        return projects
    }
    
    // MARK: Comments Response handling
    
    class func parseCommentsFrom(response: Alamofire.DataResponse<Any>,callback: @escaping ((_ success: Bool, _ comments: [Comment]) -> ())) {
        
        NetworkHelper.standardResponseHandling(response: response) { (success: Bool, error: String) in
            
            if success {
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [String : AnyObject]
                
                if let data = json["data"] as? [AnyObject] {
                    
                    let comments = NetworkHelper.parseCommentsFrom(data: data)
                    
                    callback(true, comments)
                } else {
                    callback(false, [])
                }
                
            } else {
                callback(false, [])
            }
            
        }
        
    }
    
    class func parseCommentsFrom(data: [AnyObject]) -> [Comment] {
        var comments = [Comment]()
        
        for dict in data {
            
            let id = dict["id"] as! Int
            let text = dict["text"] as! String
            let createdAt = dict["created_at"] as! String
            
            let author  = dict["author"] as! [String : AnyObject]
            
            let profile = NetworkHelper.parseProfileFrom(data: author)
            
            let comment = Comment(id: id, text: text, created_at: createdAt, profile: profile)
            
            comments.append(comment)
        }

        return comments
    }
    
    // MARK: Uploads Response handling
    
    class func parseUploadResponseFrom(response: Alamofire.DefaultDataResponse,callback: @escaping ((_ success: Bool, _ upload: Upload?) -> ())) {
        
        NetworkHelper.uploadResponseHandling(response: response) { (success, errorString) in
            
            if success {
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [String : AnyObject]
                debugPrint("JSON: \(json)")
                
                if let data = json["data"] as? [String : AnyObject] {
                    let upload = NetworkHelper.parseUploadFrom(data: data)
                    
                    callback(true, upload)
                } else {
                    callback(false, nil)
                }
                
            } else {
                callback(false, nil)
            }
            
        }
    }

    class func parseUploadsFrom(response: Alamofire.DataResponse<Any>,callback: @escaping ((_ success: Bool, _ uploads: [Upload]) -> ())) {
        
        NetworkHelper.standardResponseHandling(response: response) { (success: Bool, error: String) in
            
            if success {
                
                let json = NetworkHelper.parseResponseToJSON(data: response.data!) as! [String : AnyObject]
                debugPrint("JSON: \(json)")
                
                if let data = json["data"] as? [[String : AnyObject]] {
                    var uploads = [Upload]()
                    
                    for dict in data {

                        let parsedUpload = NetworkHelper.parseUploadFrom(data: dict) as Upload
                        uploads.append(parsedUpload)
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
    
    class func parseUploadFrom(data: [String : AnyObject]) -> Upload {
        
        let description = data["description"] as! String
        let imageURL = data["image"] as! String
        let id = data["id"] as! Int
        let commentCount = data["comment_count"] as! Int
        let createdAt = data["created_at"] as! String
        
        let projectsData = data["projects"] as! [AnyObject]
        let author  = data["author"] as! [String : AnyObject]
        
        let profile = NetworkHelper.parseProfileFrom(data: author)
        let projects = NetworkHelper.parseProjectsFrom(data: projectsData)
        
        var upload = Upload(supportedProjects: projects, imageURL: imageURL, id: String(id), created_at: createdAt, description: description, profile: profile)
        
        upload.numberOfComments = String(commentCount)
        
        return upload
    }
    
    class func parseProfileFrom(data: [String : AnyObject]) -> Profile {

        let id = data["id"] as! Int
        let email = data["email"] as! String
        var nickname = ""
        var name = ""
        let image = #imageLiteral(resourceName: "user-icon")
        var imageURL = ""
        
        if let authorNickName = data["nickname"] as? String {
            nickname = authorNickName
        }
        
        if let authorName = data["name"] as? String {
            name = authorName
        }
        
        if let avatarURL = data["avatar"] as? String {
            imageURL = avatarURL
        }
        
        //TODO cleanup
        
        var profile = Profile(id: id, name: name, email: email, nickname: nickname, avatarURL: imageURL)
        profile.image = image
        
        return profile
    }
}
