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
    
    class func send(text: String) {
        
        let notifAlert = UIAlertView(title: "Notification Alert", message: "Check your notification tray", delegate: self, cancelButtonTitle: "OK")
        notifAlert.show()
        
        let notification = UILocalNotification()
        
        notification.alertBody = text
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Badge | UIUserNotificationType.Sound, categories: nil))
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
    }
}