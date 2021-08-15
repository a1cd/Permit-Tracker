//
//  LocationViewModel.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/10/21.
//

import Foundation
import CoreLocation
import Dispatch

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var authorizationStatus: CLAuthorizationStatus
	@Published var lastSeenLocation: CLLocation?
	@Published var currentPlacemark: CLPlacemark?
	@Published var allLocations: [CLLocation] = []
	@Published var driveDetail: DriveDetails = DriveDetails(Locations: [])
	var AuthChange: () -> Void = Nothing
	
	let locationManager: CLLocationManager
	
	func requestPermission() {
		locationManager.requestWhenInUseAuthorization()
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		AuthChange()
		
		authorizationStatus = manager.authorizationStatus
		if authorizationStatus == .authorizedWhenInUse {
			locationManager.requestAlwaysAuthorization()
		}
	}
	
	override init() {
		locationManager = CLLocationManager()
		authorizationStatus = locationManager.authorizationStatus
		
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
	}
	
	// Methods
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.lastSeenLocation = locations.first
		self.fetchCountryAndCity(for: locations.first)
		if let location = locations.first {
			self.allLocations.append(location)
			self.driveDetail = DriveDetails(Locations: self.allLocations)
		}
	}

	func fetchCountryAndCity(for location: CLLocation?) {
		guard let location = location else { return }
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
			self.currentPlacemark = placemarks?.first
		}
	}
//	func newVisitReceived(_ visit: CLVisit, description: String) {
//	  let location = Location(visit: visit, descriptionString: description)
//
//	  // Save location to disk
//	}
}

