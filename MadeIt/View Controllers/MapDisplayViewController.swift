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
    
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    
    // Search box
    var searchedDestination: String!
    var savedDestination: String!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchedDestination = textField.text
        //savedDestination = textField.text
        self.mapTasks.geocodeAddress(searchedDestination, withCompletionHandler: { (status, success) -> Void in
            if !success {
                println(status)
                
                if status == "ZERO_RESULTS" {
                    println("No location found")
                }
            } else {
                let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14.0)
                self.setupLocationMarker(coordinate)
                self.savedDestination = self.mapTasks.fetchedFormattedAddress
                println("after geocoding")
                println(self.savedDestination)
            }
        })
        textField.resignFirstResponder()
        println(searchedDestination)
        return false
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as! CLLocation
            mapView.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 14.0)
            mapView.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        if locationMarker != nil {
            locationMarker.map = nil
        }
        
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        
        locationMarker.title = mapTasks.fetchedFormattedAddress
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        //locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.blueColor())
        locationMarker.opacity = 0.85
        
        locationMarker.flat = true
        locationMarker.snippet = "Your destination"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("map view did load")
        
        mapView.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        
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
            if let d = searchedDestination {
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
        println(savedDestination)
        var cdvc = segue.destinationViewController as! ContactsDisplayViewController
        cdvc.destination = savedDestination

    }
    
    override func viewWillDisappear(animated: Bool) {
        if mapView.observationInfo != nil {
            mapView.removeObserver(self, forKeyPath: "myLocation")
        }
        
    }

}
