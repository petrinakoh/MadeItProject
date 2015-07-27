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
    
    convenience init(destination: String, name: String, phone: String) {
        self.init()
        self.destination = destination
        self.name = name
        self.phone = phone
    }
    
}