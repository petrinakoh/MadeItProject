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
import GooglePlacesAutocomplete
import RealmSwift
import CoreLocation

class MapDisplayViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, NSURLConnectionDataDelegate {
    
    let googleMapsApiKey = "AIzaSyBZNBb6iHKRYXaX8ULs7wsZXg4_bWH_u4M"
    
    let realm = Realm()
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentAlert: Alert?

    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    
    // Search box
    var searchedDestination: String!
    var savedDestination: String!
    
    var placesClient: GMSPlacesClient?
    
    var destLat: Double!
    var destLong: Double!
    
    func placeAutocomplete(text: String) {
        println("placeAutoComplete called, text is \(text)");
        let filter = GMSAutocompleteFilter()
        filter.type = GMSPlacesAutocompleteTypeFilter.NoFilter
        
        let visibleRegion = self.mapView.projection.visibleRegion()
        let bounds = GMSCoordinateBounds(coordinate: visibleRegion.farLeft, coordinate: visibleRegion.farRight)
        
        placesClient?.autocompleteQuery(text, bounds: bounds, filter: filter, callback: { (results, error: NSError?) -> Void in
            if let error = error {
                println("Autocomplete error \(error)")
                // show some alertbox with some message to tell user something went wrong
                return
            }
            
            var suggestions = [] as [String]
            for result in results! {
                if let result = result as? GMSAutocompletePrediction {
                    println("\(result.attributedFullText)")
                    suggestions.append(result.attributedFullText.string)
                }
            }
            self.autocompleteTextfield.autoCompleteStrings = suggestions
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        placeAutocomplete(textField.text)
        textField.resignFirstResponder()
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
        
        placesClient = GMSPlacesClient()
        
        
        autocompleteTextfield.onTextChange = {
            (String) in
            
            println("autocompleteTextField.onTextChange")
            self.searchedDestination = String   // for checking purposes
            self.placeAutocomplete(String)
        }
        
        autocompleteTextfield.onSelect = {
            (String, NSIndexPath) in
            self.searchedDestination = String   // for checking purposes
            self.autocompleteTextfield.text = String    // to upade the textfield to the selected text
            
            self.mapTasks.geocodeAddress(String, withCompletionHandler: { (status, success) -> Void in
                if !success {
                    println(status)
                    
                    if status == "ZERO_RESULTS" {
                        println("No location found")
                        let errorMessage = UIAlertView(title: "Sorry", message: "Unable to find address. Please try again", delegate: self, cancelButtonTitle: "OK")
                        errorMessage.show()
                    }
                } else {
                    let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                    self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14.0)
                    self.setupLocationMarker(coordinate)
                    self.savedDestination = self.mapTasks.fetchedFormattedAddress
                    self.destLat = self.mapTasks.fetchedAddressLatitude
                    self.destLong = self.mapTasks.fetchedAddressLongitude
                    println("after geocoding")
                    println(self.savedDestination)
                    self.autocompleteTextfield.resignFirstResponder()
                }
            })
        }
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
                let noDestinationMessage = UIAlertView(title: "Oops!", message: "Destination could not be found. Please enter an address.", delegate: self, cancelButtonTitle: "OK")
                noDestinationMessage.show()
                return false
            }
        } else {
            return true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        println("prepareForSegue")
        println(savedDestination)
        println("DestLat is \(destLat)")
        println("DestLong is \(destLong)")
        var cdvc = segue.destinationViewController as! ContactsDisplayViewController
        cdvc.destination = searchedDestination
        cdvc.destLat = destLat
        cdvc.destLong = destLong

    }
    
    override func viewWillDisappear(animated: Bool) {
        if mapView.observationInfo != nil {
            mapView.removeObserver(self, forKeyPath: "myLocation")
        }
        
    }

}
