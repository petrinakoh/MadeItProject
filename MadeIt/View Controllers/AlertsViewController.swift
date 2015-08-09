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
import MessageUI

class AlertsViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
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
                let source = segue.sourceViewController as! MapDisplayViewController
                realm.write() {
                    realm.add(source.currentAlert!)
                }
                println("next button clicked")
                case "Save":
                let source = segue.sourceViewController as! ContactsDisplayViewController
                
                let newPerson = source.select
                
                realm.write() {
                    realm.add(source.currentAlert)
                }
                println("save button clicked")
                
            default:
                println("No one loves \(identifier)")
            }
            
            alerts = realm.objects(Alert).sorted("destination", ascending: true)
            
        }
    }


    override func viewDidLoad() {
        let realm = Realm()
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        alerts = realm.objects(Alert).sorted("destination", ascending: true)
        
        // setup observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sendMessageFromNotification:", name: "SEND_MESSAGE", object: nil)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Text Messaging
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            //UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            //UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            //UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
    }
    
    func sendMessageFromNotification(notification: NSNotification) {
        println("func sendMessageFromNotification called")
        println("notification")
        println(notification)
        if (MFMessageComposeViewController.canSendText()) {
            println("inside if statement")
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Made it!"
            let userInfo = notification.userInfo as! [String: AnyObject]
            messageVC.recipients = [userInfo["recipientNumber"]!]
            messageVC.messageComposeDelegate = self
            
            println("did func send message from notification get to this line")
            
//            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(messageVC, animated: false, completion: nil)
            
            self.presentViewController(messageVC, animated: false, completion: nil)
            println("after present view controller")
            
        }
        
    }

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
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alert = alerts[indexPath.row] as Object
            let realm = Realm()
            realm.write() {
                realm.delete(alert)
            }
            
            alerts = realm.objects(Alert).sorted("destination", ascending: true)
        }
    }
}

