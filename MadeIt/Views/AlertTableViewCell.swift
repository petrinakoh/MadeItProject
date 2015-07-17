//
//  AlertTableViewCell.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/13/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit

class AlertTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var recipientLabel: UILabel!
    
    var alert: Alert? {
        didSet {
            if let alert = alert, destinationLabel = destinationLabel, recipientLabel = recipientLabel {
                self.destinationLabel.text = alert.destination
                self.recipientLabel.text = alert.recipient
            }
        }
    }
    
}