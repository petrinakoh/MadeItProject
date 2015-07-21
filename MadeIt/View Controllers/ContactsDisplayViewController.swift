//
//  ContactsDisplayViewController.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/15/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import UIKit
import AddressBook
import RealmSwift

class ContactsDisplayViewController: UIViewController {
    
    var currentAlert: Alert?
    
    @IBOutlet weak var tableView: UITableView!

    
    let addressBookRef: ABAddressBook? = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    @IBAction func tappedAccessContacts(contactsButton: UIButton) {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            println("Denied")
            displayCantAccessContactsAlert()
        case .Authorized:
            //2
            println("Authorized")
            displayContactsList()
        case .NotDetermined:
            //3
            println("Not Determined")
            promptForAddressBookRequestAccess(contactsButton)
        }
    }


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
    
    // MARK: Permissions
    
    func promptForAddressBookRequestAccess(contactsButton: UIButton) {
        var err: Unmanaged<CFError>? = nil
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    println("Just denied")
                    self.displayCantAccessContactsAlert() // write func for this
                } else {
                    println("Just authorized")
                    //self.displayContactsList() // write func for this
                }
            }
        }
    }
    
    func displayCantAccessContactsAlert() {
        let cantAccessContactsAlert = UIAlertController(title: "Cannot Access Contacts", message: "You must give the app permission to access contacts first.", preferredStyle: .Alert)
        cantAccessContactsAlert.addAction(UIAlertAction(title: "Change Settings", style: .Default, handler: {action in
            self.openSettings()
        }))
        cantAccessContactsAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAccessContactsAlert, animated: true, completion: nil)
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }

    
    // MARK: Show Contact List
    

    
    func displayContactsList() {
        if let addressBookRef: ABAddressBook = addressBookRef {
            if let people = ABAddressBookCopyArrayOfAllPeople(addressBookRef)?.takeRetainedValue() as? NSArray {
                println("people")
                //
                //            let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
                //            cell.textLabel?.text = people[indexPath.row]
                //            return cell
                
            }
        }
        else {
            println("whoops")
        }
    }
    
}

extension ContactsDisplayViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
//        cell.textLabel?.text = people[indexPath.row]
        cell.textLabel?.text = "Test"
        
        return cell
    }
}

