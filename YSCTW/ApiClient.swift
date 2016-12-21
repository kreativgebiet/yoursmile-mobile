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
        let nickname = name.replacingOccurrences(of: " ", with: "").lowercased()
        
        let parameters: [String : String] = [
            "nickname": nickname,
            "email": email,
            "password": password,
            "name": name
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            let json = NetworkHelper.parseResponseToJSON(data: response.data!)
            
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
    
    class func login(email: String, password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String, _ profile: Profile?) -> ())) {
        
        let requestURL = baseURL + "auth/sign_in/"
        
        let parameters: [String : String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            NetworkHelper.loginResponseHandling(response: response, callback: { (success, errorString, profile) in
                callback(success, errorString, profile)
            })
        }
        
    }
    
    // MARK: Projects
    
    class func projects(callback: @escaping ((_ projects: [Project]) -> () )) {
        debugPrint("projects get")
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "projects"
            
            Alamofire.request(requestURL, method: .get, headers: token)
                .responseJSON { response in
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

    class func uploads(callback: @escaping ((_ uploads: [Upload]) -> () )) {
        debugPrint("uploads get")
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "uploads"
            
            Alamofire.request(requestURL, method: .get, headers: token)
                .responseJSON { response in
                    NetworkHelper.parseUploadsFrom(response: response, callback: { (success: Bool, uploads: [Upload]) in
                        
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
    
    class func uploadSelfies () {
        let uploadModels = CoreDataController().fetchUploadModelsToUpload()
        
        for upload in uploadModels {
            APIClient.uploadSelfie(model: upload)
        }

    }
    
    class func uploadSelfie(model: UploadModel) {
        
        //Core Data is not threadsafe so the Object needs to be fetched by ObjectID
        let objectID = model.objectID
        debugPrint("uploads post")
        NetworkHelper.verifyToken { (token) in
            
            let requestURL = baseURL + "uploads"
            
            let imageData = model.image
            let descriptionText = model.descriptionText!
            let projectIds = model.projectIds
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData!, withName: "upload[image]", fileName: "test", mimeType: "image/jpeg")
                multipartFormData.append(descriptionText.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "upload[description]")
                
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
                            
                            NetworkHelper.parseUploadResponseFrom(response: response, callback: { (success, upload) in
                                
                                let manager = CoreDataController()
                                let uploadModel = manager.managedObjectContext.object(with: objectID) as! UploadModel
                                
                                if success == true {
                                    
                                    if uploadModel.isStripePayment == true {
                                        let id = upload?.id
                                        uploadModel.backendId = id!
                                        manager.save()
                                        
                                        APIClient.postPayment(id!, { (success, error) in
                                            
                                            if success {
                                                let manager = CoreDataController()
                                                let uploadModel = manager.managedObjectContext.object(with: objectID) as! UploadModel
                                                manager.managedObjectContext.delete(uploadModel)
                                                manager.save()
                                            }
                                            
                                        })
                                    }
                                    
                                    uploadModel.isUploaded = NSNumber(booleanLiteral: true) as Bool
                                    manager.save()
                                }
                                
                            })
                            
                        }
                        
                    case .failure(let encodingError):
                        print("error:\(encodingError)")
                    }
                    
            })
            
        }
    }
    
    // MARK: Comment handling
    
    class func commentsWith(_ uploadId: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        debugPrint("comments get")
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "uploads/" + uploadId + "/comments"
            
            Alamofire.request(requestURL, method: .get, headers: token)
                .responseJSON { response in
                NetworkHelper.parseCommentsFrom(response: response, callback: { (success, comments) in
                    callback((success ? comments : []))
                })
            }
        }
        
    }
    
    class func postCommentWith(_ uploadId: String, _ text: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        debugPrint("comments post")
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "uploads/" + uploadId + "/comments"
            
            let parameters: [String : String] = [
                "comment[text]": text
            ]
            
            Alamofire.request(requestURL, method: .post, parameters: parameters, headers: token)
                .responseJSON { response in
                    NetworkHelper.parseCommentsFrom(response: response, callback: { (success, comments) in
                        callback((success ? comments : []))
                    })
            }
        }
        
    }
    
    // MARK: Stripe Payment
    
    class func postPaymentSource(_ stripeToken: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> () )) {
        debugPrint("sources post")
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "sources"
            
            let parameters: [String : String] = [
                "source": stripeToken
            ]
            
            Alamofire.request(requestURL, method: .post, parameters: parameters, headers: token)
                .responseJSON { response in
                    NetworkHelper.standardResponseHandling(response: response, callback: callback)
            }
        }
        
    }
    
    class func postPayment(_ uploadId: String, _ callback: @escaping ((_ success: Bool, _ errorMessage: String) -> () )) {
        debugPrint("upload payment post")
        NetworkHelper.verifyToken { (token) in
            let requestURL = baseURL + "uploads/" + uploadId + "/pay"
            
            Alamofire.request(requestURL, method: .post, headers: token)
                .responseJSON { response in
                    NetworkHelper.standardResponseHandling(response: response, callback: callback)
            }
        }
        
    }
    
    // MARK: User handling
    
    class func resetPassword(newPassword: String!, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        debugPrint("password post")
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
        debugPrint("delete user post")
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
