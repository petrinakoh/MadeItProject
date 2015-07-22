//
//  ReachedDestinationDetector.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/22/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import SenseSdk

class EnteredGeofenceDetector: RecipeFiredDelegate {
    
    func geofenceDetectionStart() {
        let errorPointer = SenseSdkErrorPointer.create()
        
        //create two geofences
        let hq = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Headquarters")
        let lunchSpot = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Grill")
        
        // Fire when the user reaches destination
        let trigger: Trigger? = FireTrigger.whenEntersGeofences([hq, lunchSpot])
        
        if let geofenceTrigger = trigger {
            // Recipe defines what trigger, what time of day, and how long to wait between consecutive firings
            let geofenceRecipe = Recipe(name: "ArrivedAtGeofence", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay, cooldown: Cooldown.create(oncePer: 1, frequency: CooldownTimeUnit.Days)!)
            
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
            for place in trigger.places {
                NSLog(place.description)
                let transitionDesc = args.recipe.trigger.transitionType.description
                NotificationSender.send("\(transitionDesc) \(place.description)")
            }
        }
    }
}
