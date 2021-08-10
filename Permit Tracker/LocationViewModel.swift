//
//  LocationViewModel.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/10/21.
//

import Foundation
import CoreLocation

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var authorizationStatus: CLAuthorizationStatus
	@Published var lastSeenLocation: CLLocation?
	@Published var currentPlacemark: CLPlacemark?
	@Published var allLocations: [CLLocation] = []

	private let locationManager: CLLocationManager
	
	func requestPermission() {
		locationManager.requestWhenInUseAuthorization()
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		authorizationStatus = manager.authorizationStatus
	}
	
	override init() {
		locationManager = CLLocationManager()
		authorizationStatus = locationManager.authorizationStatus
		
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startUpdatingLocation()
	}
	
	// Methods
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		lastSeenLocation = locations.first
		fetchCountryAndCity(for: locations.first)
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

