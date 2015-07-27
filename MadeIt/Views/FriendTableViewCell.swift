//
//  FriendTableViewCell.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/19/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit
import SwiftAddressBook

class FriendTableViewCell: UITableViewCell {
    
    @IBOutlet weak var personLabel: UILabel!
    
    var person: SwiftAddressBookPerson? {
        didSet {
            if let person = person, personLabel = personLabel {
                self.personLabel.text = person.firstName
            }
        }
    }
}