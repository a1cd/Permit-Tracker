//
//  Permit_TrackerApp.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import CoreLocation

var WeatherKey: String = "d31804661c01ad2f69e89ba58d23d253"

@main
struct Permit_TrackerApp: App {
    let persistenceController = PersistenceController.shared
	let state = UIApplication.shared.applicationState
	var isForeground: Bool {
		if state == .background || state == .inactive {
			return false
		} else if state == .active {
			return true
		}
	}
	
    var body: some Scene {
        WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
			
		}
    }
}
