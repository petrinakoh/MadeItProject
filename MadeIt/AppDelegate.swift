//
//  AppDelegate.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/10/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import GoogleMaps
import AddressBook
import AddressBookUI
import SenseSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let googleMapsApiKey = "AIzaSyAUb1UcBLUJKAaiZCqOYugrVtHrrDWclAk"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //testing
        GMSServices.provideAPIKey(googleMapsApiKey)
        SenseSdk.enableSdkWithKey("5ce89061-4891-409a-8549-9c8a5cd6d57f")
        
        // create custom geofence
        EnteredGeofenceDetector().geofenceDetectionStart()
        
//        // specify notification actions
//        var dismissNotification = UIMutableUserNotificationAction()
//        dismissNotification.identifier = "DismissNotification"
//        dismissNotification.title = "Dismiss"
//        dismissNotification.activationMode = UIUserNotificationActivationMode.Background
//        dismissNotification.destructive = false
//        dismissNotification.authenticationRequired = false
//        
//        var openMessageScreen = UIMutableUserNotificationAction()
//        openMessageScreen.identifier = "openMessageScreen"
//        openMessageScreen.title = "Send message"
//        openMessageScreen.activationMode = UIUserNotificationActivationMode.Foreground
//        openMessageScreen.destructive = false
//        openMessageScreen.authenticationRequired = false
//        
//        let actionsArray = NSArray(objects: openMessageScreen)
//        let actionsArrayMinimal = NSArray(objects: openMessageScreen)
        
//        var appNotificationCategory = UIMutableUserNotificationCategory()
//        appNotificationCategory.identifier = "appNotificationCategory"
//        appNotificationCategory.setActions(actionsArray as [AnyObject], forContext: UIUserNotificationActionContext.Default)
//        appNotificationCategory.setActions(actionsArrayMinimal as [AnyObject], forContext: UIUserNotificationActionContext.Minimal)
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("did receive local notification")
        let userInfo: [String: AnyObject] = notification.userInfo as! [String: AnyObject]
        let type = userInfo["type"] as! String
        switch (type) {
        case "SEND_MESSAGE":
            println("woo")
            println("user info")
            println(notification.userInfo)
            NSNotificationCenter.defaultCenter().postNotificationName("SEND_MESSAGE", object: self, userInfo: notification.userInfo)
        default:
            println("default notification")
        }
    }
    
//    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
//        println("application handle action with identifier")
//        
//        let userInfo: [String: AnyObject] = notification.userInfo as! [String: AnyObject]
//        let type = userInfo["type"] as! String
//        switch (type) {
//        case "SEND_MESSAGE":
//            println("woo")
//            println("user info")
//            println(notification.userInfo)
//            NSNotificationCenter.defaultCenter().postNotificationName("SEND_MESSAGE", object: self, userInfo: notification.userInfo)
//        default:
//            println("default notification")
//        }
//
//        completionHandler()
//    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        println("resigning app and starting geofence detection")
        EnteredGeofenceDetector().geofenceDetectionStart()
        println("Application will resign now")

    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // CHECK LOCATION ENABLED
        
        let locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        println(locationAuthorizationStatus)
        switch locationAuthorizationStatus {
        case .Denied, .Restricted, .NotDetermined:
            let enableLocationMessage = UIAlertController(title: "Wait!", message: "Location services is not enabled. Please allow access in order to detect your arrival at destination", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            enableLocationMessage.addAction(cancelAction)
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            enableLocationMessage.addAction(openAction)
            
            self.window?.rootViewController?.presentViewController(enableLocationMessage, animated: true, completion: nil)
            
        default:
            break
        }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

