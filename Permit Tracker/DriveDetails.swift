//
//  DriveDetails.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import Foundation
import CoreLocation

class DriveDetails {
	init(Locations: [CLLocation]) {
		self.Locations = Locations
	}
	init(Count: Int, coordinatesLon: [Double], coordinatesLat: [Double] , altitudes: [Double], horizontalAccuracies: [Double], verticalAccuracies: [Double], courses: [Double], courseAccuracies: [Double], speeds: [Double], speedAccuracies: [Double], timestamps: [Date]) {
		for i in 0..<Count {
			let location: CLLocation = CLLocation(
				coordinate: CLLocationCoordinate2D(latitude: coordinatesLat[i], longitude: coordinatesLon[i]),
				altitude: altitudes[i],
				horizontalAccuracy: horizontalAccuracies[i],
				verticalAccuracy: verticalAccuracies[i],
				course: courses[i],
				courseAccuracy: courseAccuracies[i],
				speed: speeds[i],
				speedAccuracy: speedAccuracies[i],
				timestamp: timestamps[i]
			)
			self.Locations.append(location)
		}
	}
	var Date: Date {
		get {
			return Locations.first?.timestamp ?? Foundation.Date()
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
}

@objc
public class locationDelist: NSObject {
	var coordinatesLon: [Double] = []
	var coordinatesLat: [Double] = []
	var altitudes: [Double] = []
	var horizontalAccuracies: [Double] = []
	var verticalAccuracies: [Double] = []
	var courses: [Double] = []
	var courseAccuracies: [Double] = []
	var speeds: [Double] = []
	var speedAccuracies: [Double] = []
	var timestamps: [Date] = []
	var date: Date
	
	init(locations: [CLLocation], date: Date) {
		self.date = date
		for location in locations {
			
			self.coordinatesLat.append(location.coordinate.latitude)
			self.coordinatesLon.append(location.coordinate.longitude)
			self.altitudes.append(location.altitude)
			
			self.horizontalAccuracies.append(location.horizontalAccuracy)
			self.verticalAccuracies.append(location.verticalAccuracy)
			
			self.courses.append(location.course)
			self.courseAccuracies.append(location.courseAccuracy)
			
			self.speeds.append(location.speed)
			self.speedAccuracies.append(location.speedAccuracy)
			
			self.timestamps.append(location.timestamp)
			
		}
	}
	var driveDetail: DriveDetails {
		get {
			DriveDetails(
				Count: timestamps.count,
				coordinatesLon: self.coordinatesLon,
				coordinatesLat: self.coordinatesLat,
				altitudes: self.altitudes,
				horizontalAccuracies: self.horizontalAccuracies,
				verticalAccuracies: self.verticalAccuracies,
				courses: self.courses,
				courseAccuracies: self.courseAccuracies,
				speeds: self.speeds,
				speedAccuracies: self.speedAccuracies,
				timestamps: self.timestamps
			)
		}
	}
}

class LocationToDataTransformer: NSSecureUnarchiveFromDataTransformer {
	
	override class func allowsReverseTransformation() -> Bool {
		return true
	}
	
	override class func transformedValueClass() -> AnyClass {
		return locationDelist.self
	}
	
	override class var allowedTopLevelClasses: [AnyClass] {
		return [locationDelist.self]
	}

	override func transformedValue(_ value: Any?) -> Any? {
		guard let data = value as? Data else {
			fatalError("Wrong data type: value must be a Data object; received \(type(of: value))")
		}
		return super.transformedValue(data)
	}
	
	override func reverseTransformedValue(_ value: Any?) -> Any? {
		guard let loc = value as? locationDelist else {
			fatalError("Wrong data type: value must be a locationDelist object; received \(type(of: value))")
		}
		return super.reverseTransformedValue(loc)
	}
}

extension NSValueTransformerName {
	static let locationToDataTransformer = NSValueTransformerName(rawValue: "LocationToDataTransformer")
}
