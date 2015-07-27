//
//  MapDisplayViewController.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/13/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import RealmSwift

class MapDisplayViewController: UIViewController, GMSMapViewDelegate {
    
    let realm = Realm()
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentAlert: Alert?

    @IBOutlet weak var showUp: UITextField!
    
    // Search box
    var savedDestination: String!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        savedDestination = textField.text
        textField.resignFirstResponder()
        println(savedDestination)
        return false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("map view did load")
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude: 151.2086, zoom: 17)
        mapView.camera = camera
        
        // Marker
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Destination"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        println("shouldPerformSegueWithIdentifier")
        
        if(identifier == "Next") {
            if let d = savedDestination {
                println("there is a destination")
                return true
            } else {
                println("there is no destination")
                return false
            }
        } else {
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue")
        var cdvc = segue.destinationViewController as! ContactsDisplayViewController
        cdvc.destination = savedDestination

    }



}
