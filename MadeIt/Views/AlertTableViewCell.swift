//
//  AlertTableViewCell.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/13/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import CoreLocation

class AlertTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!
    var switchState = true
    let switchKey = "switchState"
    
    var locationManager = CLLocationManager()
    
    var alert: Alert? {
        didSet {
            if let alert = alert, destinationLabel = destinationLabel, recipientLabel = recipientLabel, alertSwitch = alertSwitch {
                self.destinationLabel.text = alert.destination
                self.recipientLabel.text = alert.name
                self.alertSwitch.on = alert.active
            }
        }
    }
    
    @IBAction func switchClicked(alertSwitch: UISwitch) {
        if alertSwitch.on {
            

        } 
//        else {
//            println(alert!.destination)
//            println("alert is off")
//            self.switchState = false
//
//        }
        let realm = Realm()
        realm.write {
            alert?.updateActive(alertSwitch.on)
        }
        
    }
    
}

