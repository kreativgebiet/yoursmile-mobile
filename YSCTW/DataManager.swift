//
//  DataManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

let sign_up = "auth/"

class DataManager: NSObject {
    
    func registerUser(name: String, email: String, password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())
) {
        let requestURL = baseURL + sign_up
        
        let parameters: [String : String] = [
            "nickname": name,
            "email": email,
            "password": password,
            "name": name
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options:.allowFragments) as! [String:AnyObject]

                print("JSON: \(json)")
                
                if json["status"] as! String == "error" {
                    let errors = json["errors"]?["full_messages"] as! [String]
                    let errorMessage = errors.joined()
                    
                    callback(false, errorMessage)
                } else {
                    callback(true, "")
                }
                
            } catch _ {
                callback(true, "ERROR".localized)
            }
                    
        }
        
        
    }
    
    func login(email: String, password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        
        let requestURL = baseURL + "auth/sign_in/"
        
        let parameters: [String : String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options:.allowFragments) as! [String:AnyObject]
                
                print("JSON: \(json)")
                
                if let status = json["status"] as? String {
                    
                    if  status == "error" {
                        let errors = json["errors"]?["full_messages"] as! [String]
                        let errorMessage = errors.joined()
                        
                        callback(false, errorMessage)
                    } else {
                        callback(true, "")
                    }
                    
                } else {
                    
                    //TODO save user data
                    
                    let token = response.response?.allHeaderFields["Access-Token"] as! String
                    let expiryDate = response.response?.allHeaderFields["Expiry"] as! String
                    let uid = response.response?.allHeaderFields["Uid"] as! String
                    let client = response.response?.allHeaderFields["Client"] as! String
                    
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
                    
            
                    callback(true, "")
            
                    
                }
                
            } catch _ {
                callback(true, "ERROR".localized)
            }
            
        }
        
    }    
        
    func projects() -> [Project] {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]

        let requestURL = baseURL + "projects"
        
        Alamofire.request(requestURL, method: .get, headers: dictionary)
            .responseJSON { response in
                debugPrint(response)
        }
        
        return MockUpTestData().projects()
    }
    
    func uploadSelfie() -> [Project] {
        
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
    
    func resetPassword() {
        
        let dictionary = Locksmith.loadDataForUserAccount(userAccount: "myUserAccount") as! [String:String]
        
        let requestURL = baseURL + "auth/password"
        
        let parameters: [String : String] = [
        "password": "test1234",
        "password_confirmation": "test1234"
        ]
        
        Alamofire.request(requestURL, method: .put, parameters: parameters, headers: dictionary)
        .responseJSON { response in
        debugPrint(response)
        }
    }
    
    func donations() -> [Donation] {
        return MockUpTestData().donations()
    }
    
    func profile() -> Profile {
        return MockUpTestData().profile()
    }
    
    func userProfile() -> Profile {
        return MockUpTestData().userProfile()
    }

}
