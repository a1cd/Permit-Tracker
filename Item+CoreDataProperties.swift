//
//  Item+CoreDataProperties.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/6/22.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var date: Date?
    @NSManaged public var distance: Double
    @NSManaged public var id: UUID?
    @NSManaged public var notes: String?
    @NSManaged public var supervisor: String?
	@NSManaged public var timeInterval: Double
    @NSManaged public var weather: Int16
    @NSManaged public var locations: NSOrderedSet?

}

// MARK: Generated accessors for locations
extension Item {

    @objc(insertObject:inLocationsAtIndex:)
    @NSManaged public func insertIntoLocations(_ value: LocationEntity, at idx: Int)

    @objc(removeObjectFromLocationsAtIndex:)
    @NSManaged public func removeFromLocations(at idx: Int)

    @objc(insertLocations:atIndexes:)
    @NSManaged public func insertIntoLocations(_ values: [LocationEntity], at indexes: NSIndexSet)

    @objc(removeLocationsAtIndexes:)
    @NSManaged public func removeFromLocations(at indexes: NSIndexSet)

    @objc(replaceObjectInLocationsAtIndex:withObject:)
    @NSManaged public func replaceLocations(at idx: Int, with value: LocationEntity)

    @objc(replaceLocationsAtIndexes:withLocations:)
    @NSManaged public func replaceLocations(at indexes: NSIndexSet, with values: [LocationEntity])

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: LocationEntity)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: LocationEntity)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSOrderedSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSOrderedSet)

}

extension Item : Identifiable {

}
