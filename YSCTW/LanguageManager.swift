//
//  LanguageManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation

class LanguageManager: NSObject {
    
    var availableLocales = [CustomLocale]()
    static let sharedInstance = LanguageManager()
    var lprojBasePath = String()
    
    override fileprivate init() {
        
        super.init()
        let english = CustomLocale(languageCode: "en", countryCode: "en", name: "English")
        let german  = CustomLocale(languageCode: "de", countryCode: "de", name: "German")
        self.availableLocales = [english,german]
        self.lprojBasePath =  getSelectedLocale()
    }
    
    func getSelectedLocale()->String{
        
        let lang = Locale.preferredLanguages//returns array of preferred languages
        let languageComponents: [String : String] = Locale.components(fromIdentifier: lang[0])
        if let languageCode: String = languageComponents["kCFLocaleLanguageCodeKey"]{
            
            for customlocale in availableLocales {
                
                if(customlocale.languageCode == languageCode){
                    
                    return customlocale.languageCode!
                }
            }
        }
        return "en"
    }
    
    func getCurrentBundle()->Bundle{
        
        if let bundle = Bundle.main.path(forResource: lprojBasePath, ofType: "lproj"){
            
            return Bundle(path: bundle)!
            
        }else{
            
            fatalError("lproj files not found on project directory. /n Hint:Localize your strings file")
        }
    }
    
    func setLocale(_ langCode:String){
        
        UserDefaults.standard.set([langCode], forKey: "AppleLanguages")//replaces Locale.preferredLanguages
        UserDefaults.standard.synchronize()
        self.lprojBasePath =  getSelectedLocale()
    }
}


class CustomLocale: NSObject {
    var name:String?
    var languageCode:String?
    var countryCode:String?
    
    init(languageCode: String,countryCode:String,name: String) {
        
        self.name = name
        self.languageCode = languageCode
        self.countryCode = countryCode
        
    }
    
}
