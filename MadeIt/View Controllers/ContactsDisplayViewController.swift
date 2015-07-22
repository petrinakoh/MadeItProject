//
//  ContactsDisplayViewController.swift
//  MadeIt
//
//  Created by Petrina Koh on 7/15/15.
//  Copyright (c) 2015 Petrina Koh. All rights reserved.
//

import Foundation
import UIKit
import AddressBook
import SwiftAddressBook
import RealmSwift

class ContactsDisplayViewController: UITableViewController {
    
    var contacts: [SwiftAddressBookPerson] = []
    
    var currentAlert: Alert?
    
    // MARK: Permissions
    
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        ABAddressBookRequestAccessWithCompletion(nil) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    println("Just denied")
                    self.displayCantAccessContactsAlert()
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
    
    
    
    func checkPermissions() -> Bool {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            //1
            println("Denied")
            displayCantAccessContactsAlert()
            return false
        case .Authorized:
            //2
            println("Authorized")
            return true
            //addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
        case .NotDetermined:
            //3
            println("Not Determined")
            promptForAddressBookRequestAccess()
            return false
        }
    }
    
    // MARK: Show Contacts List
    
    func displayContactsList() {
        if let people: [SwiftAddressBookPerson] = swiftAddressBook?.allPeople {
            for person in people {
                println(person.nickname)
                println(person.firstName)
                println(person.lastName)
                let numbers = person.phoneNumbers
                println(numbers?.map( {$0.value} ))
                contacts.append(person)
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        println("view did appear called")
        super.viewDidAppear(true)
        
        let permission = checkPermissions()
        println(permission)
        println("check permission")
        if permission {
            println("permission")
            displayContactsList()
            self.tableView.reloadData()
        } else {
            promptForAddressBookRequestAccess()
        }
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
    
}

extension ContactsDisplayViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        //cell.person = contacts[indexPath.row]
        //cell.parentTableViewController = self
        
//        let row = indexPath.row
//        cell.textLabel?.text = people[indexPath.row]
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

