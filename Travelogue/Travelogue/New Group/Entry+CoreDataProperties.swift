//
//  Entry+CoreDataProperties.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var body: String?
    @NSManaged public var rawDate: Date?
    @NSManaged public var rawImage: Data?
    @NSManaged public var title: String?
    @NSManaged public var rawTrip: Trip?

}
