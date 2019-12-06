//
//  Trip+CoreDataClass.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//
//

import UIKit
import CoreData

@objc(Trip)
public class Trip: NSManagedObject {
    
        convenience init?(title: String?) {
            let appDelegate = UIApplication.shared.delegate as? AppDelegate  //UIKit is needed to access UIApplication
            guard let managedContext = appDelegate?.persistentContainer.viewContext,
                let title = title, title != "" else {
                    return nil
            }
            self.init(entity: Trip.entity(), insertInto: managedContext)
            self.title = title
        }
}
