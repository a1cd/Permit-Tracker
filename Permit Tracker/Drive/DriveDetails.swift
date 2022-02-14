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
//import Solar
import Dispatch

class DriveDetails {
	var test: Bool = false
	convenience init(_ locations: [CLLocation], test: Bool) {
		self.init(locations)
		self.test = test
	}
	convenience init(item: Item) {
		var newLocationList: [CLLocation] = []
		newLocationList.reserveCapacity((item.locations ?? NSOrderedSet()).count)
		
		//FIXME: - Force unwrap possible null value
		if let locations = item.locations?.array as? [LocationEntity] {
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
		newLocationList.sort(by: { one, two in
			return one.timestamp<two.timestamp
		})
		self.init(newLocationList, weather: Weather(rawValue: Int(item.weather)) ?? .Normal, notes: item.notes ?? "", distance: item.distance)
	}
	init(_ Locations: [CLLocation], weather: Weather = .Normal, notes: String = "", distance: Double? = nil) {
		self.Locations = Locations
		
		var locationList: [CLLocation] = []
		var skippedLocations: [(CLLocation, CLLocation)] = []
		if var previousLocation = Locations.first {
			for location in Locations {
				if location.timestamp.distance(to: previousLocation.timestamp) > 10 {
					skippedLocations.append((previousLocation, location))
				}
				if location.distance(from: previousLocation) > sqrt(pow(location.verticalAccuracy, 2) + pow(location.horizontalAccuracy, 2)) {
					locationList.append(location)
					previousLocation = location
				}
			}
		}
		self.notes = notes
		self.weather = weather
		self.filteredLocations = locationList
		self.skippedLocations = skippedLocations
		
		if (distance != nil) {
			self.CoreDistance = distance!
//			print(self.CoreDistance)
		} else {
			var totalDistance: Double = 0
			if var lastLocation = self.Locations.first {
				for location in self.Locations {
					totalDistance += location.distance(from: lastLocation)
					lastLocation = location
				}
			}
			self.CoreDistance = totalDistance
		}
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
	/// location pairs indicatiing when the device pauses location updates
	var skippedLocations: [(CLLocation, CLLocation)]
	var filteredLocations: [CLLocation]
	var weather: Weather = .Normal
	var notes: String = ""
	var CoreDistance: Double
	lazy var StartDate: Date = {
		return Locations.first?.timestamp ?? Foundation.Date()
	}()
	var EndDate: Date {
		return Locations.last?.timestamp ?? Foundation.Date()
	}
	var TimeInterval: TimeInterval {
		return self.StartDate.distance(to: self.EndDate)
	}
	func GetDriveDistance() -> (Measurement<UnitLength>, Double) {
		var totalDistance: Double = 0
		if var lastLocation = self.Locations.first {
			for location in self.Locations {
				totalDistance += location.distance(from: lastLocation)
				lastLocation = location
			}
		}
		return (Measurement(value: totalDistance, unit: UnitLength.meters), totalDistance)
	}
	enum Badge: Int, Identifiable {
		var id: RawValue {rawValue}
		case Day = 0
		case Twilight = 1
		case Night = 2
		case Sun = 3
		case Cloudy = 4
		case Rain = 5
		case Snow = 6
		case Fog = 7
		case Sleet = 8
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
	var driveInterval: DateInterval {
		return DateInterval(start: self.StartDate, end: self.EndDate)
	}
	
	
	func getTotalNightTime() -> TimeInterval {
		var total: TimeInterval = 0
		if let firstLoc = Locations.first {
			if let lastLoc = Locations.last {
				if let firstSol = Solar(for: firstLoc.timestamp, coordinate: firstLoc.coordinate) {
					let firstInterval = DateInterval(start: firstSol.sunrise ?? firstLoc.timestamp.previousDay().advanced(by: TimeIntervalFrom(Hours: 5)), end: firstSol.sunset ?? firstLoc.timestamp.nextDay())
					if let lastSol = Solar(for: lastLoc.timestamp, coordinate: lastLoc.coordinate) {
						let lastInterval = DateInterval(start: lastSol.sunrise ?? lastLoc.timestamp.previousDay().advanced(by: TimeIntervalFrom(Hours: 5)), end: lastSol.sunset ?? lastLoc.timestamp.nextDay())
						let firstIntervalIntersect = driveInterval.intersection(with: firstInterval)
						let lastIntervalIntersect = driveInterval.intersection(with: lastInterval)

						var totalIntervalIntersect: TimeInterval = 0

						// check to see if they are the same
						if (firstInterval.start == lastInterval.start) && (firstInterval.end == lastInterval.end) {
							totalIntervalIntersect = firstIntervalIntersect?.duration ?? 0
						} else {
							totalIntervalIntersect += firstIntervalIntersect?.duration ?? 0
							totalIntervalIntersect += lastIntervalIntersect?.duration ?? 0

							// subtract intersection intersection from total intersection
							if (firstIntervalIntersect != nil) && (lastIntervalIntersect != nil) {
								totalIntervalIntersect -= firstIntervalIntersect!.intersection(with: lastIntervalIntersect!)?.duration ?? 0
							}
						}
						// set the total to the total driving time
						total = driveInterval.duration
						total -= totalIntervalIntersect
					}
				}
			}
		}
		return total
	}
	lazy var TotalNightTime: TimeInterval = getTotalNightTime()
	lazy var TotalDayTime: TimeInterval = self.TimeInterval - self.TotalNightTime
	func asyncBadges() async -> [Badge] {
		return self.Badges()
	}
	func Badges() -> [Badge] {
		return Badges(locations: self.filteredLocations)
	}
	func Badges(locations: [CLLocation]) -> [Badge] {
		if self.test {
			return Badge.Cloudy.all
		}
		// FIXME: -
		// time badges
		var badges: [Badge] = []
		for (_, Location) in locations.enumerated() {
			if !badges.contains(.Day) && self.TotalDayTime>5 {
				badges.append(.Day)
			}
			if !badges.contains(.Day) && self.TotalNightTime>5 {
				if !badges.contains(.Night) {
					badges.append(.Night)
				}
			}
			if !badges.contains(.Twilight) && !(Solar.calculate(.sunset, for: Location.timestamp, and: .civil, at: Location.coordinate)! > Location.timestamp) && self.TotalDayTime == 0 {
				badges.append(.Twilight)
			}
		}
		return badges
	}
	lazy var lazyBadges: [Badge] = Badges()
	func maxSpeed() -> CLLocationSpeed {
		var maxSpeed: CLLocationSpeed = 0
		for location in filteredLocations {
			if maxSpeed < (location.speed - (location.speedAccuracy/2)) {
				maxSpeed = location.speed - (location.speedAccuracy/2)
			}
		}
		return maxSpeed
	}
	lazy var lazyMaxSpeed: CLLocationSpeed = maxSpeed()
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
			end.reserveCapacity(LocationList.count)
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

extension Date {
	func nextDay(_ i: Int = 1) -> Date {
		let calendar = Calendar(identifier: .gregorian)
		let nextDate = self.advanced(by: 60*60*24*Double(i))
		let nextDay = calendar.startOfDay(for: nextDate)
		return nextDay
	}
	
	func previousDay(_ i: Int = 1) -> Date {
		return nextDay(-i)
	}
}
