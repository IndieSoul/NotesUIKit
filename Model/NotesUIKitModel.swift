//
//  NotesUIKitModel.swift
//  NotesUIKit
//
//  Created by Luis Enrique Rosas Espinoza on 01/05/23.
//

import Foundation
import CoreData
import UIKit

class NotesUIKitModel {
    public static let shared = NotesUIKitModel()
    
    func context() -> NSManagedObjectContext {
        let delagate = UIApplication.shared.delegate as! AppDelegate
        return delagate.persistentContainer.viewContext
    }
    
    func saveData(title: String, note: String, date: Date, uid: UUID) {
        let context = context()
        let entityNotes = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        entityNotes.id = UUID()
        entityNotes.title = title
        entityNotes.note = note
        entityNotes.date = date
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error to save", error.localizedDescription)
        }
    }
    
    func editData(title: String, note: String, date: Date, uid: UUID, noteItem: Note) {
        let context = context()
        noteItem.setValue(title, forKey: "title")
        noteItem.setValue(note, forKey: "note")
        noteItem.setValue(date, forKey: "date")
        noteItem.setValue(uid, forKey: "id")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error to edit", error.localizedDescription)
        }
    }
}
