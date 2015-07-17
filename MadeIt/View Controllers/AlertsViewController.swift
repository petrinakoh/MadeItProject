//
//  AlertsViewController.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/10/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class AlertsViewController: UIViewController {
    
    var alerts: Results<Alert>! {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            let realm = Realm()
            switch identifier {
                case "Next":
                let source = segue.sourceViewController as! NewAlertViewController
                realm.write() {
                    realm.add(source.currentAlert!)
                }
                println("next button clicked")
                case "Save":
                let source = segue.sourceViewController as! NewAlertViewController
                realm.write() {
                    realm.add(source.currentAlert!)
                }
                println("save button clicked")
                
            default:
                println("No one loves \(identifier)")
            }
            
            alerts = realm.objects(Alert)
            
        }
    }

    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        alerts = realm.objects(Alert)
        
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


extension AlertsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! AlertTableViewCell
        
        let row = indexPath.row
        let alert = alerts[row] as Alert
        cell.alert = alert

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(alerts?.count ?? 0)
    }
}

extension AlertsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedAlert = alerts[indexPath.row]
        //self.performSegueWithIdentifier("ShowExistingAlert", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = alerts[indexPath.row] as Object
            let realm = Realm()
            realm.write() {
                realm.delete(alert)
            }
            
            alerts = realm.objects(Alert)
        }
    }
}

