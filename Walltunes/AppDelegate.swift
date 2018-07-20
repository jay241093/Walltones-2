//
//  AppDelegate.swift
//  Walltones
//
//  Created by Ravi Dubey on 6/21/18.
//  Copyright © 2018 Ravi Dubey. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import UserNotifications
import IQKeyboardManagerSwift
import AudioToolbox
import GoogleMobileAds
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
  
    

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = "676886902083-0l0fb87d3hvi3j5toms97qpiclknv57b.apps.googleusercontent.com"
        application.registerForRemoteNotifications()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9045799475036056~1055122063")
        
        
       if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })

            // For iOS 10 data message (sent via FCM
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        // Override point for customization after application launch.
        return true
    }
    
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      
        print("APNs token retrieved: \(deviceToken)")
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey:"device_token")
        UserDefaults.standard.synchronize()
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //register to receive notifications
        application.registerForRemoteNotifications()
        print("didRegisterUser")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("error here : \(error)")
        //not called
    }
  

  
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        return googleHandler || facebookHandler
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
    class func hasConnectivity() -> Bool {
        
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
        
    }


}

