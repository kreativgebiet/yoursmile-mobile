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

        //Enter your client ID of the app from the Google APIs console
        GIDSignIn.sharedInstance().clientID = "39907485128-v9puaisfv2l8hcmd2kb2dd9ek0028u25.apps.googleusercontent.com"

        //Enter your OneSignal credentials
        OneSignal.initWithLaunchOptions(launchOptions, appId: "c356a13a-8dc6-4d9e-9f22-8b302cb1e2e7")

        //Enter your Stripe credentials (Payment)
        //pk_test_cX8rDspcsLdUPz5yKSDZ5QRm
        //pk_live_7bLZF5x44IPX9tnYxDIimKJ6

        STPPaymentConfiguration.shared().publishableKey = "pk_test_cX8rDspcsLdUPz5yKSDZ5QRm"


        //Enter your Paypal credentials (Payment)
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "ENKX0hpI1-TqMxV3ONjkY1KD_i1UXiELUofXDwA9OKSZDQ-OhZks1WQM-rg_rgxSq4ftNmWxWGO68-YF", PayPalEnvironmentSandbox: "AZD5t0HYfLAljRLLAaLmsuWDE3pir2W2ieE4tk0cJ5_3SSAqs3sCJBDjAQ5SOOwT_T7HNWQNm05RQ4-m"])

        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow(frame: UIScreen.main.bounds)

        var initialViewController: UIViewController!

        if UserDefaults.standard.value(forKey: "didOnboarding") as? Bool == true {
            if let loggedIn = UserDefaults.standard.value(forKey: "loggedIn") as? Bool {
                if loggedIn == true {
                    initialViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
                } else {
                    initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
                }
            } else {
                initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController")
            }

        } else {
            initialViewController = storyboard.instantiateViewController(withIdentifier: "OVC")
        }

        let animationScreen = storyboard.instantiateViewController(withIdentifier: "LaunchAnimationViewController")

        self.window?.rootViewController = animationScreen

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            self.window?.rootViewController = initialViewController
        })

        self.window?.makeKeyAndVisible()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let isHandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as! String?, annotation: options[.annotation])

        let google = GIDSignIn.sharedInstance().handle(url, sourceApplication: options   [UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                       annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return isHandled || google
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

