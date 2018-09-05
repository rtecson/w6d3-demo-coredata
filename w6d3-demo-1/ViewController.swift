//
//  ViewController.swift
//  w6d3-demo-1
//
//  Created by Roland on 2018-09-05.
//  Copyright © 2018 Lighthouse Labs. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
//        let username = nameTextField.text ?? ""
        
        // Save username to user defaults
//        UserDefaults.standard.setValue(username, forKey: usernameKey)
        
        readData()
    }
    
    private let usernameKey = "MyUserName"
    private var appDelegate: AppDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get my app delegate object from the UIApplication singleton object
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            self.appDelegate = appDelegate
        }
        
//        // Read username from user defaults
//        if let username = UserDefaults.standard.value(forKey: usernameKey) as? String {
//            // Successfully retrieved username from UserDefaults
//            nameTextField.text = username
//        }
//        else {
//            // username has not been saved in UserDefaults
//            nameTextField.text = "I don't know your username"
//        }
    }
    
    func saveData() {
        guard let appDelegate = self.appDelegate else {
            assertionFailure("Unable to retrieve app delegate")
            return
        }
        
        // Create our managed objects
        let context = appDelegate.persistentContainer.viewContext
        let bob = Person(context: context)
        bob.name = "Bob"
        bob.age = 25
        
        let rufus = Pet(context: context)
        rufus.name = "Rufus"
        
        rufus.owner = bob
        bob.pet = [ rufus ]
        
        let james = Person(context: context)
        james.name = "James"
        james.age = 30
        
        // Tell CoreData to save now, but if you left this out, CoreData will still save sometime later
        appDelegate.saveContext()
    }
    
    func readData() {
        guard let appDelegate = self.appDelegate else {
            assertionFailure("Unable to retrieve app delegate")
            return
        }
        
        // Get a request object that knows how to retrieve Person objects from CoreData
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        
        // Only retrieve person objects where name is equal to "Bob"
        request.predicate = NSPredicate(format: "ANY name == %@", "Bob")
        
        let context = appDelegate.persistentContainer.viewContext
        if let results = try? context.fetch(request) {
            // If successful, results will be an array of Person objects
            for person in results {
                print("Retrieved \(String(describing: person.name)) who is \(String(describing: person.age)) years old")
                
                // Check to see if there are any pets
                if let pets = person.pet {
                    // Iterate through all pets
                    for pet in pets {
                        // Cast pet (Any) to Pet
                        guard let pet = pet as? Pet else {
                            assertionFailure("Unexpected non-pet object found")
                            continue // continues to the next item in the for loop
                        }
                        print("Pet's name is \(String(describing: pet.name))")
                    }
                }
            }
        }
        else {
            print("Unable to retrieve data")
        }
    }
}

