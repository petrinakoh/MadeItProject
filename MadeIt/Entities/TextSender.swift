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
import SenseSdk

class TextSender: UIViewController, MFMessageComposeViewControllerDelegate {
    
    var selectedPerson: AddressPerson?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("text sender viewdidload")
    }
    
    // MARK: Test geofence trigger
    
    @IBAction func triggerGeofence(sender: UIButton) {
        
        // create two geofences
        let hq = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Headquarters")
        let lunchSpot = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Grill")
        
        let errorPointer = SenseSdkErrorPointer.create()
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
        
        // for testing
        SenseSdkTestUtility.fireTrigger(fromRecipe: "ArrivedAtGeofence", confidenceLevel: ConfidenceLevel.Medium, places: [hq, lunchSpot], errorPtr: errorPointer)
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        println("button tapped")
        if (MFMessageComposeViewController.canSendText()) {
            println("inside if statement")
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Made it!"
            messageVC.recipients = ["718-564-9360", "217-898-7054"]
            messageVC.messageComposeDelegate = self
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }

    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
}