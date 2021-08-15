//
//  DriveDetails.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import Foundation
import CoreLocation
import CoreData
import SwiftUI

class DriveDetails {
	init(item: Item) {
		
		var newLocationList: [CLLocation] = []
		
		//FIXME - Force unwrap possible null value
		if let locations = item.locations!.array as? [LocationEntity] {
			for entity in locations {
				
				let coordinate = CLLocationCoordinate2D(
					latitude: entity.latitude,
					longitude: entity.longitude
				)
				
				let location = CLLocation(
					coordinate: coordinate,
					altitude: entity.altitude,
					horizontalAccuracy: entity.horizontalAccuracy,
					verticalAccuracy: entity.verticalAccuracy,
					course: entity.course,
					courseAccuracy: entity.courseAccuracy,
					speed: entity.speed,
					speedAccuracy: entity.speedAccuracy,
					timestamp: entity.timestamp!
				)
				newLocationList.append(location)
			}
		}
		self.Locations = newLocationList
	}
	init(Locations: [CLLocation]) {
		self.Locations = Locations
	}
	var StartDate: Date {
		return Locations.first?.timestamp ?? Foundation.Date()
   }
	var EndDate: Date {
		return Locations.last?.timestamp ?? Foundation.Date()
   }
	var TimeInterval: TimeInterval {
		return self.StartDate.distance(to: self.EndDate)
	}
	var Locations: [CLLocation] = []
	var Locations2d: [CLLocationCoordinate2D] {
		get {
			var locs: [CLLocationCoordinate2D] = []
			for i in Locations {
				locs.append(i.coordinate)
			}
			return locs
		}
	}
	func SpeedGraph(_ num: Int = 15) -> [CGFloat] {
		let chunks = chunkIt(LocationList: Locations, num: num)
		var speeds = [1]
		
		var chunkAverages: [CGFloat] = []
		for chunk in chunks {
			var total: Double = 0
			for location in chunk {
				total += location.speed
			}
			chunkAverages.append(CGFloat(total/Double(chunk.count)))
		}
		return chunkAverages
	}
	func chunkIt(LocationList: [CLLocation], num: Int)  -> [[CLLocation]]{
		let EndEstCount = Int(floor(Double(LocationList.count)/Double(num)))
		var out: [[CLLocation]] = [[]]
		out.remove(at: 0)
		
		var last = 0
		for i in 0..<num {
			let aStart = EndEstCount * i
			let aEnd = aStart + EndEstCount
			out.append(Array(LocationList[aStart..<aEnd]))
			last += 1
		}
		let remaining = Array(LocationList[(EndEstCount * last)..<LocationList.count])
		for (i, location) in remaining.enumerated() {
			var chunk = out[i]
			chunk.append(location)
			out[i] = chunk
		}
		
		return out
	}
	func convertToCoreData(context: NSManagedObjectContext) -> [LocationEntity]{
		var locationEntities: [LocationEntity] = []
		
		for location in self.Locations {
			let entity = LocationEntity(context: context)
			
			
			entity.latitude = location.coordinate.latitude
			entity.longitude = location.coordinate.longitude
			entity.horizontalAccuracy = location.horizontalAccuracy
			entity.verticalAccuracy = location.verticalAccuracy
			entity.altitude = location.altitude
			entity.course = location.course
			entity.courseAccuracy = location.courseAccuracy
			entity.speed = location.speed
			entity.speedAccuracy = location.speedAccuracy
			entity.timestamp = location.timestamp
			
			locationEntities.append(entity)
		}
		return locationEntities
	}
}
