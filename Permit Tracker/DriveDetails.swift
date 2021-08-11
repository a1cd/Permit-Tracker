//
//  DriveDetails.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import Foundation
import CoreLocation

class DriveDetails {
	init(locations: [CLLocation]) {
		self.locations = locations
		Date = (locations.first?.timestamp ?? Foundation.Date())
	}
	var Date: Date
	var locations: [CLLocation]
	var Locations2d: [CLLocationCoordinate2D] {
		get {
			var locs: [CLLocationCoordinate2D] = []
			for i in locations {
				locs.append(i.coordinate)
			}
			return locs
		}
	}
	
}
