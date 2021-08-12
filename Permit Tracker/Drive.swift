//
//  Drive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit

struct Drive: View {
	@ObservedObject var locationViewModel: LocationViewModel
	
	@State var driveDetail: DriveDetails?
	
	var label: some View {
		Text("Drive on \(Date().description(with: .autoupdatingCurrent))")
	}
	
    var body: some View {
		GroupBox(label: label) {
			if (driveDetail == nil) {
				MapView(driveDetails: locationViewModel.driveDetail, isDriving: true)
					.frame(height: 200)
			} else {
				MapView(driveDetails: driveDetail!, isDriving: true)
					.frame(height: 200)
			}
		}
    }
}

//struct Drive_Previews: PreviewProvider {
//    static var previews: some View {
//		Drive(locationViewModel: <#Binding<LocationViewModel>#>, DriveDetail: DriveDetails(Locations: []))
//    }
//}
