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
	var test: Bool = true
	convenience init(_ locations: [CLLocation], test: Bool) {
		self.init(Locations: locations)
		self.test = test
	}
	convenience init(item: Item) {
		
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
//		self.Locations = newLocationList
		self.init(Locations: newLocationList)
	}
	init(Locations: [CLLocation]) {
		self.Locations = Locations
		
		var locationList: [CLLocation] = []
		var inaccurateLocations: [(CLLocation, CLLocation)] = []
		if var previousLocation = Locations.first {
			for location in Locations {
				if location.timestamp.distance(to: previousLocation.timestamp) > 10 {
					inaccurateLocations.append((previousLocation, location))
				}
				if location.distance(from: previousLocation) > sqrt(pow(location.verticalAccuracy, 2) + pow(location.horizontalAccuracy, 2)) {
					locationList.append(location)
					previousLocation = location
				}
			}
		}
		self.filteredLocations = locationList
		self.innacurateLocations = inaccurateLocations
	}
	lazy var StartDate: Date = {
		return Locations.first?.timestamp ?? Foundation.Date()
	}()
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
		case Fog
		case Sleet
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
			case .Fog:
				return("cloud.fog.fill", false, Color(UIColor.systemGray))
			case .Snow:
				return ("cloud.snow.fill", false, Color(UIColor.systemGray))
			default:
				return ("questionmark.diamond.fill", false, Color(UIColor.systemYellow))
			}
		}
		var all: [Badge] {
			return [.Day, .Twilight, .Night, .Sun, .Cloudy, .Rain, .Snow, .Fog, .Sleet]
		}
	}
	var driveInterval: DateInterval {DateInterval(start: self.StartDate, end: self.EndDate)}
	func isLocationAtNight(_ Location: CLLocation) -> Bool {
		let calendar = Calendar.init(identifier: .gregorian)
		var sunset: Date = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: firstLocation.timestamp) ?? firstLocation.timestamp.advanced(by: TimeIntervalFrom(Days: 1)))
		if let solar = Solar(for: Location.timestamp, coordinate: Location.coordinate) {
			if let sunset = solar.sunset {
				// if it is past sunset
				if sunset < Location.timestamp {
					
				}
			}
		}
		return false
	}
	func getTotalNightTime() -> TimeInterval {
		var total: TimeInterval = 0
		let nightInterval: DateInterval
		driveInterval.intersection(with: <#T##DateInterval#>)
		return total
	}
	lazy var TotalNightTime: TimeInterval = getTotalNightTime()
	lazy var Badges: [Badge] = {
		if self.test {
			return Badge.Cloudy.all
		}
		// FIXME: -
		// time badges
		var badges: [Badge] = []
		for (_, Location) in filteredLocations.enumerated() {
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
	}()
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
	var innacurateLocations: [(CLLocation, CLLocation)]
	var filteredLocations: [CLLocation]
	lazy var maxSpeed: CLLocationSpeed = {
		var maxSpeed: CLLocationSpeed = 0
		for location in filteredLocations {
			if maxSpeed < (location.speed - (location.speedAccuracy/2)) {
				maxSpeed = location.speed - (location.speedAccuracy/2)
			}
		}
		return maxSpeed
	}()
	func SpeedGraph(_ num: Int = 15) -> [CGFloat] {
		let chunks = chunkIt(LocationList: filteredLocations, num: num)
		
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
