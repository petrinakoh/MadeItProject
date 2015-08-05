//
//  ReachedDestinationDetector.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/22/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import SenseSdk
import RealmSwift

class EnteredGeofenceDetector: RecipeFiredDelegate {
    
    var alerts: Results<Alert>! 
    
    var savedDestination: String!
    
    var destinationAddress: CustomGeofence!
    
    func geofenceDetectionStart() {
        println("geofence detection func")
        println(savedDestination)
        
        let errorPointer = SenseSdkErrorPointer.create()
        
//        // For actual alert destinations
//        let realm = Realm()
//        alerts = realm.objects(Alert)
//        for alert in alerts {
//            if alert.active {
//                let destinationAddress = CustomGeofence(latitude: alert.destLat, longitude: alert.destLong, radius: 50, customIdentifier: "destinationAddress")
//                println("address is \(alert.destination)")
//                println("destLat is \(alert.destLat)")
//                println("destLong is \(alert.destLong)")
//                
//                let trigger: Trigger? = FireTrigger.whenEntersGeofences([destinationAddress, destinationAddress])
//                
//                if let geofenceTrigger = trigger {
//                    let geofenceRecipe = Recipe(name: "ArrivedAtGeofence", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay)
//                    
//                    SenseSdk.register(recipe: geofenceRecipe, delegate: self)
//                }
//                
//                if errorPointer.error != nil {
//                    NSLog("Error!: \(errorPointer.error.message)")
//                }
//            }
//        }
        

           
        
    
    
        //create two geofences
        
//        let pnp  = CustomGeofence(latitude: 37.3839997, longitude: -122.0127699, radius: 30, customIdentifier: "Headquarters")
        let home = CustomGeofence(latitude: 37.380959, longitude: -122.031358, radius: 50, customIdentifier: "Grill")
        
        // Fire when the user reaches destination
        let trigger: Trigger? = FireTrigger.whenEntersGeofences([home])
        
        if let geofenceTrigger = trigger {
            // Recipe defines what trigger, what time of day, and how long to wait between consecutive firings
            let geofenceRecipe = Recipe(name: "ArrivedAtGeofence", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay)
            
            // Register the unique recipe
            SenseSdk.register(recipe: geofenceRecipe, delegate: self)
        }
        
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
        
        
    }


    @objc func recipeFired(args: RecipeFiredArgs) {
        // user entered destination
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            NotificationSender.sendNotification("sending notification")
            TextSender().sendTextMessage()
            for place in trigger.places {
                NSLog(place.description)
                let transitionDesc = args.recipe.trigger.transitionType.description
                NotificationSender.send("\(transitionDesc) \(place.description)")
            }
        }
    }
}
