//
//  Item+CoreDataClass.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/6/22.
//
//

import Foundation
import CoreData
import CoreLocation
import Accelerate

@objc(Item)
public class Item: NSManagedObject {
	public func update() {
		GetDriveDistance()
	}
	public func GetDriveDistance() -> (Measurement<UnitLength>, Double) {
		if distance == 0.0 {
			var totalDistance: Double = 0
			if var lastLocation = self.locations?.firstObject as? LocationEntity {
				for location in self.locations!.array as! [LocationEntity] {
					let dist = location.distance(from: lastLocation)
					if dist > sqrt(pow(location.verticalAccuracy, 2) + pow(location.horizontalAccuracy, 2)) {
						totalDistance += dist
						lastLocation = location
					}
				}
			}
//			print("in ns, totalDist =",totalDistance)
			self.distance = totalDistance
		}
		return (Measurement(value: distance, unit: UnitLength.meters), distance)
	}
}
