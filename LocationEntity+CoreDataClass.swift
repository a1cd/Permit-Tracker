//
//  LocationEntity+CoreDataClass.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/6/22.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(LocationEntity)
public class LocationEntity: NSManagedObject {
	var asCLLocation: CLLocation {
		return CLLocation(
			coordinate: CLLocationCoordinate2D(
				latitude: self.latitude,
				longitude: self.longitude
			),
			altitude: self.altitude,
			horizontalAccuracy: self.horizontalAccuracy,
			verticalAccuracy: self.verticalAccuracy,
			course: self.course,
			courseAccuracy: self.courseAccuracy,
			speed: self.speed,
			speedAccuracy: self.speedAccuracy,
			timestamp: self.timestamp!
		)
	}
	func distance(from: CLLocation) -> CLLocationDistance {
		return self.asCLLocation.distance(from: from)
	}
	func distance(from: LocationEntity) -> CLLocationDistance {
		return self.asCLLocation.distance(from: from.asCLLocation)
	}
}
