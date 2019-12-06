//
//  EntryTableViewController.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//

import UIKit

class EntrysTableViewController: UITableViewController {
    
    @IBOutlet var entryTableView: UITableView!
    
    var trip: Trip?
    var entries = [Entry]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = trip?.title ?? ""
               
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
           
           self.present(alert, animated: true, completion: nil)
       }
    
    func updateDocumentsArray() {
        entries = trip?.entry?.sortedArray(using: [NSSortDescriptor(key: "title", ascending: true)]) as? [Entry] ?? [Entry]()
    }
    
    func deleteEntry(at indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        
        if let managedObjectContext = entry.managedObjectContext {
            managedObjectContext.delete(entry)
            
            do {
                try managedObjectContext.save()
                self.entries.remove(at: indexPath.row)
                entryTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                alertNotifyUser(message: "Delete failed.")
                entryTableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entrytCell", for: indexPath)
        
        if let cell = cell as? EntryTableViewCell {
            let entry = entries[indexPath.row]
            cell.titleLabel.text = entry.title
            if let modifiedDate = entry.modifiedDate {
                cell.modifiedDateLabel.text = dateFormatter.string(from: modifiedDate)
            } else {
                cell.modifiedDateLabel.text = "unknown"
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteEntry(at: indexPath)
        }
        
        return [delete]
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntrysTableViewController,
            let segueIdentifier = segue.identifier {
            destination.trip = trip
            if (segueIdentifier == "existingEntry") {
            }
        }
    }
    

}
