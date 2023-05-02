//
//  AddNoteViewController.swift
//  NotesUIKit
//
//  Created by Luis Enrique Rosas Espinoza on 01/05/23.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextEdit: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    
    var note: Note?
    var uid = UUID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = note != nil ? "Edit Note" : "Add Note"

        self.titleTextField.text = note?.title
        self.noteTextEdit.text = note?.note
        self.datePicker.date = note?.date ?? Date()
        self.uid = note?.id ?? UUID()
        if note == nil {
            validateTextAddNote()
        } else {
            validateTextEditNote()
        }
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if note != nil {
            NotesUIKitModel.shared.editData(
                title: titleTextField.text!,
                note: noteTextEdit.text,
                date: datePicker.date,
                uid: uid,
                noteItem: note!
            )
        } else {
            NotesUIKitModel.shared.saveData(
                title: titleTextField.text!,
                note: noteTextEdit.text,
                date: datePicker.date,
                uid: uid
            )
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    func validateTextAddNote() {
        saveButton.isEnabled = false
        titleTextField.addTarget(self, action: #selector(validateTextField), for: .editingChanged)
    }
    
    func validateTextEditNote() {
        titleTextField.addTarget(self, action: #selector(validateTextField), for: .editingChanged)
    }
    
    @objc func validateTextField() {
        guard let titleValidate = titleTextField.text, !titleValidate.isEmpty else {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
