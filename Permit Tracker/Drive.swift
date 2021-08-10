//
//  Drive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit

struct Drive: View {
	var driveDetails: DriveDetails
	var label: some View {
		Text("Drive on \(Date().description(with: .autoupdatingCurrent))")
	}
    var body: some View {
		GroupBox(label: label) {
			MapView()
				.frame(height: 200)
		}
    }
}

struct Drive_Previews: PreviewProvider {
    static var previews: some View {
		Drive(driveDetails: DriveDetails(Date: Date(), Interval: Date().distance(to: Date()), locations: []))
    }
}
