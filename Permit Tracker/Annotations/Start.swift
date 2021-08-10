//
//  Start.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/10/21.
//

import UIKit
import MapKit

class Start: NSObject, MKAnnotation {
	init(Location: CLLocationCoordinate2D) {
		coordinate = Location
	}
	
	// This property must be key-value observable, which the `@objc dynamic` attributes provide.
	@objc dynamic var coordinate: CLLocationCoordinate2D
	
	// Required if you set the annotation view's `canShowCallout` property to `true`
	var title: String? = "Start"
	
	// This property defined by `MKAnnotation` is not required.
	var subtitle: String? = "Where that one drive began"
}
