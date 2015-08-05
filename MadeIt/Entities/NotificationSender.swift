//
//  NotificationSender.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/22/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit

class NotificationSender {
    
    func setupNotificationSettings() {
        // specify notification types
        var notificationTypes: UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Sound
        
        
        
    }

    
    class func send(text: String) {
        
        let notifAlert = UIAlertView(title: "Notification Alert", message: "Check your notification tray", delegate: self, cancelButtonTitle: "OK")
        notifAlert.show()
        
        let notification = UILocalNotification()
        
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil))
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
    }
    
    class func sendNotification(text: String) {
        var notif = UILocalNotification()
        notif.alertBody = "Remember to text..."
        notif.alertAction = "open"
        notif.category = "appNotificationCategory"
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notif)
    }

}