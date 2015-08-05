//
//  TextSender.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/23/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import RealmSwift
import SenseSdk

class TextSender: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var alerts: Results<Alert>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("text sender viewdidload")
    }
    
    // MARK: Test geofence trigger
    
    @IBAction func triggerGeofence(sender: UIButton) {
        
        println("trigger geofence button pressed")
        
        
        // create two geofences
//        let pnp = CustomGeofence(latitude: 37.3839997, longitude: -122.0127699, radius: 30, customIdentifier: "Headquarters")
        let home = CustomGeofence(latitude: 37.380959, longitude: -122.031358, radius: 50, customIdentifier: "Grill")
        
        let errorPointer = SenseSdkErrorPointer.create()
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
        
        // for testing
        SenseSdkTestUtility.fireTrigger(fromRecipe: "ArrivedAtGeofence", confidenceLevel: ConfidenceLevel.Medium, places: [home], errorPtr: errorPointer)
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
            println(errorPointer.error)
        }
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        println("button tapped")
        if (MFMessageComposeViewController.canSendText()) {
            println("inside if statement")
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Made it!"
            messageVC.recipients = ["217-898-7054"]
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }

    }
    
    func sendTextMessage() {
        println("func sendTextMessage called")
        if (MFMessageComposeViewController.canSendText()) {
            println("inside if statement")
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Made it!"
            messageVC.recipients = ["217-898-7054"]
            messageVC.messageComposeDelegate = self

//            self.presentViewController(messageVC, animated: false, completion: nil)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(messageVC, animated: false, completion: nil)
        }
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
//            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)

            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)

            //self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)

            //self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
}