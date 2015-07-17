//
//  NewAlertViewController.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/13/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import GoogleMaps

class NewAlertViewController: UIViewController {
    
    var currentAlert: Alert?

    override func viewDidLoad() {
        super.viewDidLoad()

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
