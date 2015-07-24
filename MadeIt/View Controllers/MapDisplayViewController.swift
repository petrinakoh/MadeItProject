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
    
    @IBOutlet weak var mapView: GMSMapView!
    var currentAlert: Alert?

    @IBOutlet weak var showUp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude: 151.2086, zoom: 6)
        
        // Trying to get label over the mapView
        mapView.camera = camera
        //mapView.delegate = self
        self.view.insertSubview(mapView, atIndex:0)
        //self.view = mapView
        self.view.addSubview(showUp)
        self.view.bringSubviewToFront(showUp)
        
        // Marker
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "frustration"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        println("mapview")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        currentAlert = Alert()
        currentAlert!.destination = "School"
        currentAlert!.recipient = "send to someone"
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
