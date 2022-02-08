//
//  LocationEntity+CoreDataProperties.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/6/22.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var altitude: Double
    @NSManaged public var course: Double
    @NSManaged public var courseAccuracy: Double
    @NSManaged public var horizontalAccuracy: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var speedAccuracy: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var verticalAccuracy: Double
    @NSManaged public var item: Item?

}

extension LocationEntity : Identifiable {

}
