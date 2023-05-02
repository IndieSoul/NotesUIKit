//
//  HomeTableViewController.swift
//  NotesUIKit
//
//  Created by Luis Enrique Rosas Espinoza on 01/05/23.
//

import UIKit
import CoreData

class HomeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var notes: [Note] = []
    var fetchResultController: NSFetchedResultsController<Note>!

    override func viewDidLoad() {
        super.viewDidLoad()
        showNotes()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = notes[indexPath.row]
        
        cell.textLabel?.text = note.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        
        cell.detailTextLabel?.text = dateFormatter.string(from: note.date ?? Date())
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let context = NotesUIKitModel.shared.context()
            let delete = self.fetchResultController.object(at: indexPath)
            context.delete(delete)
            
            do {
                try context.save()
                print("Delete")
            } catch let error as NSError {
                print("No delete", error.localizedDescription)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "send", sender: self)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send" {
            if let id = self.tableView.indexPathForSelectedRow {
                let row = notes[id.row]
                let destination = segue.destination as! AddNoteViewController
                destination.note = row
            }
        }
    }
    
    //MARK: - CoreData
    
    func showNotes() {
        let context = NotesUIKitModel.shared.context()
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let order = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [order]
        fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            notes = fetchResultController.fetchedObjects!
        } catch let error as NSError {
            print("Not data", error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        default:
            self.tableView.reloadData()
        }
        
        self.notes = controller.fetchedObjects as! [Note]
    }

}
