//
//  Trip+CoreDataProperties.swift
//  Travelogue
//
//  Created by Steven Perrin on 12/3/19.
//  Copyright © 2019 Steven Perrin. All rights reserved.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }
    
    @NSManaged public var title: String?
    @NSManaged public var entry: NSOrderedSet?

}

// MARK: Generated accessors for entry
extension Trip {

    @objc(insertObject:inEntryAtIndex:)
    @NSManaged public func insertIntoEntry(_ value: Entry, at idx: Int)

    @objc(removeObjectFromEntryAtIndex:)
    @NSManaged public func removeFromEntry(at idx: Int)

    @objc(insertEntry:atIndexes:)
    @NSManaged public func insertIntoEntry(_ values: [Entry], at indexes: NSIndexSet)

    @objc(removeEntryAtIndexes:)
    @NSManaged public func removeFromEntry(at indexes: NSIndexSet)

    @objc(replaceObjectInEntryAtIndex:withObject:)
    @NSManaged public func replaceEntry(at idx: Int, with value: Entry)

    @objc(replaceEntryAtIndexes:withEntry:)
    @NSManaged public func replaceEntry(at indexes: NSIndexSet, with values: [Entry])

    @objc(addEntryObject:)
    @NSManaged public func addToEntry(_ value: Entry)

    @objc(removeEntryObject:)
    @NSManaged public func removeFromEntry(_ value: Entry)

    @objc(addEntry:)
    @NSManaged public func addToEntry(_ values: NSOrderedSet)

    @objc(removeEntry:)
    @NSManaged public func removeFromEntry(_ values: NSOrderedSet)

}
