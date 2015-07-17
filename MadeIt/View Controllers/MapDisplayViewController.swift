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
    

//    @IBOutlet weak var destinationSearchBar: UISearchBar!
    
//    @IBOutlet weak var destinationLabel: UILabel!
//    @IBOutlet weak var mapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var camera = GMSCameraPosition.cameraWithLatitude(-33.868, longitude: 151.2086, zoom: 6)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        var marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello world"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        self.view = mapView

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
