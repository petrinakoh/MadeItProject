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
import SenseSdk

class ContactsDisplayViewController: UITableViewController {
    
    var destination: String!
    
    var selectedPerson: AddressPerson?
    
    @IBOutlet weak var searchContacts: UISearchBar!
    
    enum State {
        case DefaultMode
        case SearchMode
    }

    var state: State = .DefaultMode
    
    var contactStorage: [AddressPerson] = []
    var contactsToDisplay: [AddressPerson] = []
    
    var currentAlert: Alert!
    
    // MARK: Test geofence trigger
    
    func saveToDisplay(stuffToStore: [AddressPerson]) {
        self.contactsToDisplay = stuffToStore
        self.contactsToDisplay.sort {
            $0.name.localizedCaseInsensitiveCompare($1.name) == NSComparisonResult.OrderedAscending
        }
        self.tableView.reloadData()
    }
    
    @IBAction func triggerGeofence(sender: UIButton) {
        
        // create two geofences
        let hq = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Headquarters")
        let lunchSpot = CustomGeofence(latitude: 37.124, longitude: -127.456, radius: 50, customIdentifier: "Grill")
        
        let errorPointer = SenseSdkErrorPointer.create()
        if errorPointer.error != nil {
            NSLog("Error!: \(errorPointer.error.message)")
        }
        
        // for testing 
        SenseSdkTestUtility.fireTrigger(fromRecipe: "ArrivedAtGeofence", confidenceLevel: ConfidenceLevel.Medium, places: [hq, lunchSpot], errorPtr: errorPointer)
        if errorPointer.error != nil {
            NSLog("Error sending trigger")
        }
    }
    
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
                    self.contactStorage = self.getContacts()
                    self.saveToDisplay(self.contactStorage)
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
    
    func getContacts() -> [AddressPerson] {
        var contactsToReturn: [AddressPerson] = []
        if let people: [SwiftAddressBookPerson] = swiftAddressBook?.allPeople {
            for person in people {
//                println(person.nickname)
//                println(person.firstName)
//                println(person.lastName)
                let numbers = person.phoneNumbers
//                println(numbers?.map( {$0.value} ))
                
                let p = AddressPerson()
                if let firstName = person.firstName {
                    p.firstName = firstName
                }
                if let lastName = person.lastName {
                    p.lastName = lastName
                }
                if let phoneNumbers = person.phoneNumbers {
                    p.phone = phoneNumbers[0].value
                }
                
                contactsToReturn.append(p)
            }
        }
        return contactsToReturn
    }


    override func viewDidLoad() {
        println("viewdidload ContactsDisplayViewController")
        searchContacts.delegate = self
        super.viewDidLoad()
        println(destination)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        println("ContactsDisplayVC view did appear called")
        super.viewDidAppear(true)
        
        let permission = checkPermissions()
//        println("check if permission is..")
//        println(permission)
        if permission {
            println("permission")
            contactStorage = getContacts()
            saveToDisplay(contactStorage)
        } else {
            promptForAddressBookRequestAccess()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        println("shouldPerformSegueWithIdentifier")
        
        if(identifier == "Save") {
            if let p = selectedPerson {
                println("there is a person")
                return true
            } else {
                println("there is no person")
                return false
            }
        } else {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "Save") {
            // this goes back to the main dashboard
            currentAlert = Alert(destination: destination, name: selectedPerson!.name, phone: selectedPerson!.phone)
            
        }
    }
    // Search for Contact
    
    func searchContacts(contacts: [AddressPerson], searchString: String) -> [AddressPerson] {
        println("searchContacts")
        if searchString == "" {
            return contacts
        }
        var peopleThatMatch: [AddressPerson] = []
        for person in contacts {
            if checkString(person.name, searchString: searchString) {
                peopleThatMatch.append(person)
            }
        }
        println(peopleThatMatch)
        return peopleThatMatch
    }
    
    func checkString(str: String, searchString: String) -> Bool {
        if str.lowercaseString.rangeOfString(searchString) != nil {
            println("exists")
            return true
        } else {
            return false
        }
    }
    
    

    
}

extension ContactsDisplayViewController: UITableViewDataSource {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsToDisplay.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendTableViewCell
        //cell.person = contacts[indexPath.row]
        //cell.parentTableViewController = self
        
        let row = indexPath.row
        let person = contactsToDisplay[row]
//        cell.textLabel?.text = people[indexPath.row]
        println("at override func tableview")
        println(person.firstName)
        cell.textLabel?.text = "\(person.firstName) \(person.lastName)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("didSelectRowAtIndexPath")
        selectedPerson = contactsToDisplay[indexPath.row]
        println(selectedPerson)
    }
}

extension ContactsDisplayViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("searchbar text did begin editing")
        state = .SearchMode
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("Search bar cancel button clicked")
        state = .DefaultMode
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        println("searchBar func")
        print("contacts to display")
        println(contactsToDisplay)
        
        saveToDisplay(searchContacts(contactStorage, searchString: searchText))
    }
}