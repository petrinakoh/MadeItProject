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
    
    var i: Int = 0
    
    var alerts: Results<Alert>! 
    
    var savedDestination: String!
    
    var destinationAddress: CustomGeofence!
    
    var customArray: [CustomGeofence] = []
    
    func geofenceDetectionStart() {
        println("geofence detection func")
        println(savedDestination)
        
        let errorPointer = SenseSdkErrorPointer.create()
        
        // For actual alert destinations
        let realm = Realm()
        alerts = realm.objects(Alert)
        for alert in alerts {
            if alert.active {
                if let phone = alert.phone {
                    let cg = CustomGeofence(latitude: alert.destLat, longitude: alert.destLong, radius: 30, customIdentifier: phone)
                    customArray.append(cg)
                    i = i + 1
                    println(i)
                    println("OAUCJS CUSTOM ARRAY HERE")
                    println("&&&&&&&&&&&& custom array phone number \(customArray[i-1].customIdentifier)")
                }
                
                
//                let destinationAddress = CustomGeofence(latitude: alert.destLat, longitude: alert.destLong, radius: 30, customIdentifier: "destinationAddress")
//                println("address is \(alert.destination)")
//                println("destLat is \(alert.destLat)")
//                println("destLong is \(alert.destLong)")
                
                
                let trigger: Trigger? = FireTrigger.whenEntersGeofences(customArray)
                
                if let geofenceTrigger = trigger {
                    let geofenceRecipe = Recipe(name: "ArrivedAtGeofence", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay)
                    
                    SenseSdk.register(recipe: geofenceRecipe, delegate: self)
                }
                
                if errorPointer.error != nil {
                    NSLog("Error!: \(errorPointer.error.message)")
                }
            }
        }


           
        
    
    
//        //create two geofences
//        
////        let pnp  = CustomGeofence(latitude: 37.3839997, longitude: -122.0127699, radius: 30, customIdentifier: "pnp")
//        let home = CustomGeofence(latitude: 37.380959, longitude: -122.031358, radius: 50, customIdentifier: "home")
//        
//        // Fire when the user reaches destination
//        let trigger: Trigger? = FireTrigger.whenEntersGeofences([home])
//        
//        if let geofenceTrigger = trigger {
//            // Recipe defines what trigger, what time of day, and how long to wait between consecutive firings
//            let geofenceRecipe = Recipe(name: "ArrivedAtGeofence", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay)
//            
//            // Register the unique recipe
//            SenseSdk.register(recipe: geofenceRecipe, delegate: self)
//        }
//        
//        if errorPointer.error != nil {
//            NSLog("Error!: \(errorPointer.error.message)")
//        }
        
        
    }
    
    


                    
    
    


    @objc func recipeFired(args: RecipeFiredArgs) {
        // user entered destination
        NSLog("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            
            for place in trigger.places {
                println("place description is here omfg what happedn")
                println(place.description)
                NotificationSender.sendNotification(place.description)
                //TextSender().sendTextMessage(place.description)
                NSLog(place.description)
                let transitionDesc = args.recipe.trigger.transitionType.description
//                NotificationSender.send("\(transitionDesc) \(place.description)")
            }
        }
    }
}
