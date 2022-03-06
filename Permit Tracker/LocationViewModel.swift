//
//  LocationViewModel.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/10/21.
//

import Foundation
import CoreLocation
import Dispatch
import UIKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
	@Published var authorizationStatus: CLAuthorizationStatus
	@Published var lastSeenLocation: CLLocation?
	@Published var currentPlacemark: CLPlacemark?
	@Published var allLocations: [CLLocation] = []
	@Published var driveDetail: DriveDetails = DriveDetails([])
	var AuthChange: () -> Void = {}
	
	let locationManager: CLLocationManager
	
	func requestPermission() {
		locationManager.requestWhenInUseAuthorization()
	}

	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		AuthChange()
		
		authorizationStatus = manager.authorizationStatus
		if authorizationStatus == .authorizedWhenInUse {
			locationManager.requestAlwaysAuthorization()
		} else if authorizationStatus == .authorizedAlways {
			locationManager.allowsBackgroundLocationUpdates = true
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
		self.locationManager.stopMonitoringSignificantLocationChanges()
		self.locationManager.startUpdatingLocation()
		if (UIDevice.current.batteryState == .full || UIDevice.current.batteryState == .charging) {
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
			self.locationManager.pausesLocationUpdatesAutomatically = false
			//FIXME: add more stuff here
		} else {
			self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
			self.locationManager.pausesLocationUpdatesAutomatically = true
			if (UIDevice.current.batteryLevel < 0.25) {
				self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
				self.locationManager.distanceFilter = 110
			}
		}
		//FIXME: add code for when the phone starts to overheat
		self.lastSeenLocation = locations.last
		self.fetchCountryAndCity(for: locations.last)
		self.allLocations.append(contentsOf: locations)
		self.driveDetail = DriveDetails(self.allLocations)
	}
	func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
		self.locationManager.stopUpdatingLocation()
		self.locationManager.startMonitoringSignificantLocationChanges()
		UserDefaults.standard.set(UserDefaults.standard.string(forKey: "status") ??  "" + "resumed", forKey: "status")
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		UserDefaults.standard.set(error.localizedDescription + " at " + DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .medium), forKey: "failed")
	}
	
	func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
		UserDefaults.standard.set(UserDefaults.standard.string(forKey: "status") ??  "" + "resumed", forKey: "status")
		self.locationManager.startUpdatingLocation()
	}
	func fetchCountryAndCity(for location: CLLocation?) {
		guard let location = location else { return }
		let geocoder = CLGeocoder()
		geocoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
			self.currentPlacemark = placemarks?.first
//			if placemarks != nil {
//				if let printerPlacemark = placemarks!.first {
//					print(printerPlacemark)
//					print(printerPlacemark.subThoroughfare)
//				}
//			}
		}
	}
//	func newVisitReceived(_ visit: CLVisit, description: String) {
//	  let location = Location(visit: visit, descriptionString: description)
//
//	  // Save location to disk
//	}
}

