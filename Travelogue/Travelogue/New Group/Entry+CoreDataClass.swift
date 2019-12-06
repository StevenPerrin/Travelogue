//
//  Entry+CoreDataClass.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Entry)
public class Entry: NSManagedObject {
    
        var modifiedDate: Date? {
            get {
                return rawDate as Date?
            }
            set {
                rawDate = newValue as NSDate? as Date?
            }
        }
    
    var image: UIImage? {
        get {
            if let imageData = rawImage as Data? {
                return UIImage(data: imageData)
            } else {
                return nil
            }
        }
        set {
            if let image = newValue {
                rawImage = convertImageToNSData(image: image) as Data?
            }
        }
    }
        
    convenience init?(title: String?, body: String?, image: UIImage?) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
            guard let managedContext = appDelegate?.persistentContainer.viewContext,
                let title = title, title != "" else {
                    return nil
            }
            self.init(entity: Entry.entity(), insertInto: managedContext)
            self.title = title
            self.body = body
            
            if let image = image {
                self.rawImage = convertImageToNSData(image: image) as Data?
            }
            
            self.modifiedDate = Date(timeIntervalSinceNow: 0)
            self.rawTrip = rawTrip
        }
        
        func update(title: String, body: String?, rawTrip: Trip) {
            self.title = title
            self.body = body
           
            self.modifiedDate = Date(timeIntervalSinceNow: 0)
            self.rawTrip = rawTrip
        }
    
    func convertImageToNSData(image: UIImage) -> NSData? {
           // The image data can be represented as PNG or JPEG data formats.
           // Both ways to format the image data are listed below and the JPEG version is the one being used.
           
           //return image.jpegData(compressionQuality: 1.0) as NSData?
           return processImage(image: image).pngData() as NSData?
       }
    
    func processImage(image: UIImage) -> UIImage {
           if (image.imageOrientation == .up) {
               return image
           }
           
           UIGraphicsBeginImageContext(image.size)
           
           image.draw(in: CGRect(origin: CGPoint.zero, size: image.size), blendMode: .copy, alpha: 1.0)
           let copy = UIGraphicsGetImageFromCurrentImageContext()
           
           UIGraphicsEndImageContext()
           
           guard let unwrappedCopy = copy else {
               return image
           }
           
           return unwrappedCopy
       }
}
