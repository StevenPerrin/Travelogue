//
//  EntryTableViewController.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/6/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//

import UIKit

class EntryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    let dateFormatter = DateFormatter()
    let newEntryDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    var entry: Entry?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

            bodyTextView.layer.borderWidth = 1.0
            bodyTextView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
            bodyTextView.layer.cornerRadius = 6.0
               
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .medium
               
            newEntryDateFormatter.dateStyle = .medium
               
            if let entry = entry {
                titleTextField.text = entry.title
                bodyTextView.text = entry.body
                if let modifiedDate = entry.modifiedDate {
                    dateLabel.text = dateFormatter.string(from: modifiedDate)
                }
                image = entry.image
                imageView.image = image
               } else {
                   titleTextField.text = ""
                   bodyTextView.text = ""
                   dateLabel.text = newEntryDateFormatter.string(from: Date(timeIntervalSinceNow: 0))
                   imageView.image = nil
               }
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
    }
    
    
    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "This device has no camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           defer {
               imagePickerController.dismiss(animated: true, completion: nil)
           }
           
           guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
               return
           }
           image = selectedImage
           imageView.image = image
           if let entry = entry {
               entry.image = selectedImage
           }
       }
       
       func alertNotifyUser(message: String) {
           let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
        alertNotifyUser(message: "Please enter a title before saving the note.")
        return
    }
            if let entry = entry {
                entry.title = title
                entry.body = bodyTextView.text
                entry.image = image
            } else {
                entry = Entry(title: title, body: bodyTextView.text, image: image) 
            }
            
           
            if let entry = entry {
                do {
                    let managedContext = entry.managedObjectContext
                    try managedContext?.save()
                } catch {
                    alertNotifyUser(message: "The entry could not be saved.")
                }
                
            } else {
                alertNotifyUser(message: "The entry could not be created.")
            }
            
            navigationController?.popViewController(animated: true)
        }

   

}
