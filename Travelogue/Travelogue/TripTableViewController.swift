//
//  TripTableViewController.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//

import UIKit
import CoreData

class TripTableViewController: UITableViewController {

    @IBOutlet var tripTableView: UITableView!
    
    var trips = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Trips"
    }

    override func viewWillAppear(_ animated: Bool) {
           fetchTrips(searchString: "")
       }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Add Trip", message: "Enter a new trip name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let title = textField.text {
                let tripTitle = title.trimmingCharacters(in: .whitespaces)
                if (tripTitle == "") {
                    self.alertNotifyUser(message: "Trip could not be created. \nTitle must have a value.")
                    return
                }
                self.addTrip(title: tripTitle)
            } else {
                self.alertNotifyUser(message: "Trip not created.\n Title is not accessible.")
                return
            }
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Trip name"
            textField.isSecureTextEntry = false
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func edit(at indexPath: IndexPath){
        let trip = trips[indexPath.row]
        let alert = UIAlertController(title: "Edit Trip", message: "Enter new Trip title", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let title = textField.text {
                let tripTitle = title.trimmingCharacters(in: .whitespaces)
                if (tripTitle == ""){
                    self.alertNotifyUser(message: "Trip name not changed.\nA name is required.")
                    return
                }
                if (tripTitle == trip.title){
                    //same as old name
                    return
                }
                if (self.tripExists(title: tripTitle)){
                    self.alertNotifyUser(message: "Trip name not changed. \n\(tripTitle) already exists.")
                    return
                }
                self.updateTrip(at: indexPath, title: tripTitle)
            } else {
                self.alertNotifyUser(message: "Trip name not changed. \nTrip not accessible.")
                return
            }
            
        }))
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "trip name"
            textField.isSecureTextEntry = false
            textField.text = trip.title
    })
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertNotifyUser(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTrip(title: String){
        if (tripExists(title: title)) {
            alertNotifyUser(message: "Trip \(title) already exists.")
            return
        }
        
        let trip = Trip(title: title)
        
        if let trip = trip {
            do {
                let managedObjectContext = trip.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                print("Trip could not be saved")
            }
        } else {
            print("Trip could not be created")
        }
        
        fetchTrips(searchString: "")
    }
    
    func fetchTrips(searchString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Trip>()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
               do {
                   if (searchString != "") {
                       fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", searchString)
                   }
                   trips = try managedContext.fetch(fetchRequest)
                   tripTableView.reloadData()
               } catch {
                   print("Fetch could not be performed")
               }
    }
    
    func tripExists(title: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, title != "" else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func confirmDeleteTrip(at indexPath: IndexPath){
        let trip = trips[indexPath.row]
        
        if let entrySet = trip.entry, entrySet.count > 0 {
            let title = trip.title ?? "Trip"
            let alert = UIAlertController(title: "Delete Trip", message: "\(title) contains entries. Are you sure you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                self.tripTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
               (alertAction) -> Void in
                self.deleteTrip(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            deleteTrip(at: indexPath)
        }
    }
    
    func deleteTrip(at indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        
        if let managedObjectContext = trip.managedObjectContext {
            managedObjectContext.delete(trip)
            
            do {
                try managedObjectContext.save()
                self.trips.remove(at: indexPath.row)
                tripTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Deletion failed: \(error).")
                tripTableView.reloadData()
            }
        }
    }
    
    func updateTrip(at indexPath: IndexPath, title: String) {
        let trip = trips[indexPath.row]
        trip.title = title
        
        if let managedObjectContext = trip.managedObjectContext {
            do {
                try managedObjectContext.save()
                fetchTrips(searchString: "")
            } catch {
                print("Update failed.")
                tripTableView.reloadData()
            }
        }
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trips.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        let trip = trips[indexPath.row]
        cell.textLabel?.text = trip.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
         let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
             action, index in
             self.confirmDeleteTrip(at: indexPath)
         }
         
         let edit = UITableViewRowAction(style: .default, title: "Edit") {
             action, index in
             self.edit(at: indexPath)
         }
         edit.backgroundColor = UIColor.blue
     
         return [delete, edit]
     }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? EntryTableViewController,
//            let row = tripTableView.indexPathForSelectedRow?.row {
//            destination.trip = trips[row]
//        }
    }
    
    
    


