//
//  ApiClient.swift
//  YSCTW
//
//  Created by Max Zimmermann on 22.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import Alamofire
import Locksmith

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
                let errors = NetworkHelper.findErrorsIn(json!) as String
                    
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
    
    class func projects() -> [Project] {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
        
        let requestURL = baseURL + "projects"
        
        Alamofire.request(requestURL, method: .get, headers: dictionary)
            .responseJSON { response in
                debugPrint(response)
        }
        
        return MockUpTestData().projects()
    }
    
    // MARK: Upload Selfies
    
    class func uploadSelfie() -> [Project] {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
        
        let requestURL = baseURL + "uploads"
        
        let parameters: [String : String] = [
            "password": "test1234",
            "password_confirmation": "test1234"
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, headers: dictionary)
            .responseJSON { response in
                debugPrint(response)
        }
        
        return MockUpTestData().projects()
    }
    
    // MARK: Reset Password
    
    class func resetPassword(newPassword: String!, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
        
        let requestURL = baseURL + "auth/password"
        
        let parameters: [String : String] = [
            "password": newPassword,
            "password_confirmation": newPassword
        ]
        
        Alamofire.request(requestURL, method: .put, parameters: parameters, headers: dictionary)
            .responseJSON { response in
            NetworkHelper.standardResponseHandling(response: response, callback: callback)
        }
    }

}
