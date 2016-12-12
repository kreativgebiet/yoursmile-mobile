//
//  ApiClient.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Locksmith
import SwiftyJSON

let sign_up = "auth/"

class APIClient: NSObject {
    
    // MARK: Registration
    
    class func registerUser(name: String, email: String, password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())
        ) {
        let requestURL = baseURL + sign_up
        
        let parameters: [String : String] = [
            "nickname": name,
            "email": email,
            "password": password,
            "name": name
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            let json = NetworkHelper.parseResponseToJSON(data: response.data!)
            debugPrint("JSON: \(json)")
            
            if (json == nil) {
                callback(true, "ERROR".localized)
            } else {
                let errors = NetworkHelper.findErrorsIn(json! as! [String : AnyObject]) as String
                    
                if errors.characters.count > 0 {
                    callback(false, errors)
                } else {
                    callback(true, "")
                }
            }
        }
    }
    
    // MARK: Login
    
    class func login(email: String, password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        let requestURL = baseURL + "auth/sign_in/"
        
        let parameters: [String : String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            NetworkHelper.standardResponseHandling(response: response, callback: callback)
        }
        
    }
    
    // MARK: Projects
    
    class func projects(callback: @escaping ((_ projects: [Project]) -> () )) {
        
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "projects"
            
            Alamofire.request(requestURL, method: .get, headers: token)
                .responseJSON { response in
                    debugPrint("projects")
                    debugPrint(response)
                    debugPrint(String(data: response.data!, encoding: String.Encoding.utf8))
                    
                    NetworkHelper.parseProjectsFrom(response: response, callback: { (success: Bool, projects: [Project]) in
                        
                        if success == true {                            
                            callback(projects)
                        } else {
                            callback([])
                        }
                        
                    })
            }
            
        }
    
    }
    
    // MARK: Uploads

    class func uploads(callback: @escaping ((_ uploads: [Donation]) -> () )) {
        
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "uploads"
            
            Alamofire.request(requestURL, method: .get, headers: token)
                .responseJSON { response in
                    debugPrint("uploads")
                    debugPrint(response)
                    debugPrint(String(data: response.data!, encoding: String.Encoding.utf8))
                    
                    NetworkHelper.parseUploadsFrom(response: response, callback: { (success: Bool, uploads: [Donation]) in
                        
                        if success == true {
                            callback(uploads)
                        } else {
                            callback([])
                        }
                        
                    })
            }
            
        }
        
    }
    
    // MARK: Upload Selfies
    
    class func uploadSelfie(image: UIImage, description: String, userId: String, projectIds: [Int]) {
        
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "uploads"
            let imageData = UIImageJPEGRepresentation(image, 0.1)!
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData, withName: "upload[image]", fileName: "test", mimeType: "image/jpeg")
                multipartFormData.append(description.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "upload[description]")
                
                for projectId in projectIds {
                    multipartFormData.append("\(projectId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "upload[project_ids][]")
                }
                
                }, to: requestURL, method: .post, headers: token,
                   encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showUploadNotificationIdentifier), object: nil, userInfo: ["request": upload])
                        
                        upload.uploadProgress { progress in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: uploadProgressNotificationIdentifier), object: nil, userInfo: ["progress": progress])
                            print(Float(progress.fractionCompleted))
                        }
                        
                        upload.response { response in
                            debugPrint(response)
                            debugPrint(String(data: response.data!, encoding: String.Encoding.utf8))
                        }
                        
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
                    
            })
            
        }
    }
    
    // MARK: User handling
    
    class func resetPassword(newPassword: String!, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "auth/password"
            
            let parameters: [String : String] = [
                "password": newPassword,
                "password_confirmation": newPassword
            ]
            
            Alamofire.request(requestURL, method: .put, parameters: parameters, headers: token)
                .responseJSON { response in
                    NetworkHelper.standardResponseHandling(response: response, callback: callback)
            }
        }
    }
    
    class func deleteUser(callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "auth/"
            
            Alamofire.request(requestURL, method: .delete, headers: token)
                .responseJSON { response in
                    NetworkHelper.standardResponseHandling(response: response, callback: callback)
            }
        }
        
    }
    
    class func updateUser(email: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "auth/"
            
            let parameters: [String : String] = [
                "email": email
            ]
            
            Alamofire.request(requestURL, method: .patch, parameters: parameters, headers: token)
                .responseJSON { response in
                    NetworkHelper.standardResponseHandling(response: response, callback: callback)
            }
        }
    }
    
}
