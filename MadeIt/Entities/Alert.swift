//
//  Alert.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/13/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import RealmSwift

class Alert : Object {
    
    dynamic var destination: String = ""
    dynamic var name: String? = ""
    dynamic var phone: String? = ""
    dynamic var destLong: Double = 0
    dynamic var destLat: Double = 0
    dynamic var active: Bool = true
    dynamic var added: Bool = false

    
    convenience init(destination: String, name: String, phone: String, destLong: Double, destLat: Double, alertSwitch: Bool) {
        self.init()
        self.destination = destination
        self.name = name
        self.phone = phone
        self.destLong = destLong
        self.destLat = destLat
        self.active = alertSwitch
    }
    
    func updateActive(status: Bool) {
        self.active = status
    }
    
    func updateAdded(added: Bool) {
        self.added = added
    }
    
}