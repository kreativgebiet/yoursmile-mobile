//
//  AppDelegate.swift
//  YSCTW
//
//  Created by Max Zimmermann on 06.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit
import Stripe
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Enter your credentials
        OneSignal.initWithLaunchOptions(launchOptions, appId: "5eb5a37e-b458-11e3-ac11-000c2940e62c")
        
        //Enter your credentials
        STPPaymentConfiguration.shared().publishableKey = "pk_test_HoCc151BfYh437wFFtMoRVUy"
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                                PayPalEnvironmentSandbox: "YOUR_CLIENT_ID_FOR_SANDBOX"])
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        var initialViewController: UIViewController!
        
        if UserDefaults.standard.value(forKey: "didOnboarding") as? Bool == true {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LVC")
        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "OVC")
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String!, annotation: options[.annotation])
        return isHandled
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

