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
    
    var destinationAddress: CustomGeofence!
    
    var customArray: [CustomGeofence] = []
    
    func geofenceDetectionStart() {
        println("geofence detection func")
        
        let errorPointer = SenseSdkErrorPointer.create()
        
        let realm = Realm()
        alerts = realm.objects(Alert)
        for alert in alerts {
            let dateNow = NSDate().timeIntervalSince1970
            if alert.active {
                if !alert.added {
                    println("alert phone number is \(alert.phone)")
                    let cg = CustomGeofence(latitude: alert.destLat, longitude: alert.destLong, radius: 100, customIdentifier: alert.phone)
                    let trigger: Trigger? = FireTrigger.whenEntersGeofences([cg])
                    if let geofenceTrigger = trigger {
                        println("create recipe")
                        let cd = Cooldown.create(oncePer: 5, frequency: CooldownTimeUnit.Minutes)
                        let geofenceRecipe = Recipe(name: "ArrivedAtGeofence-\(alert.phone)-\(dateNow)", trigger: geofenceTrigger, timeWindow: TimeWindow.allDay, cooldown: cd!)
                        SenseSdk.register(recipe: geofenceRecipe, delegate: self)
                        realm.write{
                            alert.updateActive(true)
                        }
                        
                    }
                }
            } else {
                if alert.added {
                    SenseSdk.unregister(name: "ArrivedAtGeofence-\(alert.phone)-\(dateNow)")
                    realm.write{
                        alert.updateActive(false)
                    }
                }
                
            }
        }
        
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
    }


    @objc func recipeFired(args: RecipeFiredArgs) {
        // user entered destination
        println("Recipe \(args.recipe.name) fired at \(args.timestamp).");
        for trigger in args.triggersFired {
            
            for place in trigger.places {
                println("place \(place.description)")
                NotificationSender.sendNotification(place.description)
                let transitionDesc = args.recipe.trigger.transitionType.description
            }
        }
    }
}
