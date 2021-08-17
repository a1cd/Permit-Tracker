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
import Solar

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
//		self.init(Locations: newLocationList)
	}
	init(Locations: [CLLocation]) {
		self.Locations = Locations
//		
//		var locationList: [CLLocation] = []
//		var inaccurateLocations: [(CLLocation, CLLocation)] = []
//		if var previousLocation = Locations.first {
//			for location in Locations {
//				if location.timestamp.distance(to: previousLocation.timestamp) > 10 {
//					inaccurateLocations.append((previousLocation, location))
//				}
//				if location.distance(from: previousLocation) > sqrt(pow(location.verticalAccuracy, 2) + pow(location.horizontalAccuracy, 2)) {
//					locationList.append(location)
//					previousLocation = location
//				}
//			}
//		}
//		self.filteredLocations = locationList
//		self.innacurateLocations = inaccurateLocations
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
	enum Badge {
		case Day
		case Twilight
		case Night
		case Sun
		case Cloudy
		case Rain
		case Snow
		var icon: (String, Bool, Color?) {
			switch self {
			case .Cloudy:
				return ("cloud.fill", false, Color(UIColor.systemGray))
			case .Day:
				return ("sun.max.fill", true, nil)
			case .Night:
				return ("moon.fill", false, Color(UIColor.systemBlue))
			case .Rain:
				return ("cloud.rain.fill", true, nil)
			case .Twilight:
				return ("sun.haze.fill", true, nil)
			default:
				return ("questionmark.diamond.fill", false, Color(UIColor.systemYellow))
			}
		}
	}
	var TotalNightTime: TimeInterval {
		var total: TimeInterval = 0
		for (i, Location) in Locations.enumerated() {
			if var solar = Solar(for: Location.timestamp, coordinate: Location.coordinate) {
				solar.calculate()
				if !solar.isDaytime {
					if (i != 0) && (i != Locations.count) {
						let prevLoc = Locations[i-1]
						if let prevSol = Solar(for: prevLoc.timestamp, coordinate: prevLoc.coordinate) {
							if !prevSol.isDaytime {
								total += 1
							}
						}
					}
				}
			}
		}
		return total
	}
	var Badges: [Badge] {
		// time badges
		var badges: [Badge] = []
		for (i, Location) in Locations.enumerated() {
			if var solar = Solar(for: Location.timestamp, coordinate: Location.coordinate) {
				solar.calculate()
				if !badges.contains(.Day) && solar.isDaytime {
					badges.append(.Day)
				}
				if !solar.isDaytime {
					if !badges.contains(.Night) {
						badges.append(.Night)
					}
				}
				if !badges.contains(.Twilight) && !(solar.civilSunset! > Location.timestamp) && !solar.isDaytime {
					badges.append(.Twilight)
				}
			}
		}
		return badges
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
//	var innacurateLocations: [(CLLocation, CLLocation)]
//	var filteredLocations: [CLLocation]
	var maxSpeed: CLLocationSpeed {
		var max: CLLocationSpeed = 0
		for location in Locations {
			if max < (location.speed - (location.speedAccuracy/2)) {
				max = location.speed - (location.speedAccuracy/2)
			}
		}
		return max
	}
	func SpeedGraph(_ num: Int = 15) -> [CGFloat] {
		let chunks = chunkIt(LocationList: Locations, num: num)
		
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
	func chunkIt(LocationList: [CLLocation], num: Int)  -> [[CLLocation]] {
		if (LocationList.count <= num) {
			var end: [[CLLocation]] = []
			for location in LocationList {
				end.append([location])
			}
			return end
		}
		
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
