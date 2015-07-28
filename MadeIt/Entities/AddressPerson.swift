//
//  AddressPerson.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/21/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//



import Foundation
import RealmSwift

class AddressPerson : Object {
    
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var phone: String = ""
    dynamic var name: String {
        return firstName + " " + lastName
    }
}