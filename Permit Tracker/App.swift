//
//  Permit_TrackerApp.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import CoreLocation

@main
struct Permit_TrackerApp: App {
    let persistenceController = PersistenceController.shared
	
    var body: some Scene {
        WindowGroup {
			ContentView()
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
		}
    }
}
