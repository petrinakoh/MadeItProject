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
import CoreLocation

class MapDisplayViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    let realm = Realm()
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentAlert: Alert?

    @IBOutlet weak var showUp: UITextField!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    // Search box
    var savedDestination: String!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        savedDestination = textField.text
        textField.resignFirstResponder()
        println(savedDestination)
        return false
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 10.0)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("map view did load")
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
//        var camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude: 151.2086, zoom: 6)
//        mapView.camera = camera
//        
//        // Marker
//        var marker = GMSMarker()
//        marker.position = camera.target
//        marker.snippet = "Destination"
//        marker.appearAnimation = kGMSMarkerAnimationPop
//        marker.map = mapView
        
        // Location manager
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            mapView.myLocationEnabled = true
        }
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
    
    override func viewWillDisappear(animated: Bool) {
        if mapView.observationInfo != nil {
            mapView.removeObserver(self, forKeyPath: "myLocation")
        }
        
    }

}
