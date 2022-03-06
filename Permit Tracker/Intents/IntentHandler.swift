//
//  IntentHandler.swift
//  Driving Tracker Intents
//
//  Created by Everett Wilber on 2/17/22.
//

import Intents
import SwiftUI

class IntentHandler: INExtension, StartDriveIntentHandling {
	var locationViewModel = LocationViewModel()
	func handle(intent: StartDriveIntent) async -> StartDriveIntentResponse {
		let persistenceController = PersistenceController.shared
		var response = StartDriveIntentResponse(code: .success, userActivity: nil)
		
		locationViewModel = LocationViewModel()
		
		return response
	}
	
}
