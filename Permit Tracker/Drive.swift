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
	
	var realDriveDetail: DriveDetails {
		if (driveDetail == nil) {
			return locationViewModel.driveDetail
		} else {
			return driveDetail!
		}
	}
	
	var label: some View {
		if (driveDetail == nil) {
			return Text("Your drive \(itemFormatter.string(from: locationViewModel.driveDetail.StartDate))")
		} else {
			return Text("Your drive \(itemFormatter.string(from: driveDetail!.StartDate))")
		}
	}
	func GetDriveDistance() -> (Measurement<UnitLength>, Double) {
		var totalDistance: Double = 0
		if var lastLocation = realDriveDetail.Locations.first {
			for location in realDriveDetail.Locations {
				totalDistance += location.distance(from: lastLocation)
				lastLocation = location
			}
		}
		return (Measurement(value: totalDistance, unit: UnitLength.meters), totalDistance)
	}
	var TotalMarkerDistance: Double {
		return GetDriveDistance().1
	}
	var PredictedDistance: Double {
		if let lastMarker = realDriveDetail.Locations.last {
			// getting data
			let speed = lastMarker.speed
			let timeSinceMarker = lastMarker.timestamp.distance(to: Date())
			
			// using data
			let distTraveledSinceLastMarker = timeSinceMarker * speed
			
			return TotalMarkerDistance + distTraveledSinceLastMarker
		}
		return TotalMarkerDistance
	}
	
	var isDriving: Bool {
		return driveDetail == nil
	}
	
	@State var Distance: Measurement<UnitLength> = Measurement.init(value: 0, unit: UnitLength.meters)
	
	func GetTimeInterval() -> String {
		if (isDriving) {
			return realDriveDetail.TimeInterval.stringFromTimeInterval(isApptx: !isDriving)
		} else {
			// dont show while driving because location refresh is not exactly 1 second
			return realDriveDetail.TimeInterval.stringFromTimeInterval(isApptx: !isDriving)
		}
	}
	@State var SpeedTimer = Timer.publish(every: 0.1, tolerance: 0.05, on: .current, in: .default).autoconnect()
    var body: some View {
		GroupBox(label: label) {
			VStack {
				if (driveDetail == nil) {
					MapView(driveDetails: locationViewModel.driveDetail, isDriving: true)
						.frame(height: 400)
				} else {
					MapView(driveDetails: driveDetail!, isDriving: false)
						.frame(height: 200)
				}
				HStack {
					Image(systemName: "ruler")
					Text("Distance")
					Spacer()
					if isDriving {
						Text(distFormatter.string(from: Distance) )
							.onReceive(SpeedTimer, perform: { _ in
								Distance = Measurement(value: PredictedDistance, unit: UnitLength.meters)
							})
							.font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
					} else {
						Text(distFormatter.string(from: GetDriveDistance().0))
					}
				}
				HStack {
					Image(systemName: "stopwatch")
					Text("Time")
					Spacer()
					Text(GetTimeInterval())
				}
			}
		}
    }
}
var distFormatter: MeasurementFormatter {
	let formatter = MeasurementFormatter()
	formatter.numberFormatter.maximumFractionDigits = 2
	formatter.numberFormatter.minimumFractionDigits = 2
	formatter.unitOptions = .naturalScale
	formatter.unitStyle = .long
	
	return formatter
}

extension TimeInterval{
	func stringFromTimeInterval(isApptx: Bool = false) -> String {

		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.formattingContext = .standalone
		formatter.zeroFormattingBehavior = .dropLeading
		formatter.includesApproximationPhrase = isApptx
		formatter.allowsFractionalUnits = isApptx
		formatter.allowedUnits = [.day, .hour, .minute]
		
		return formatter.string(from: self.rounded())!
	}
}

//struct Drive_Previews: PreviewProvider {
//    static var previews: some View {
//		Drive(locationViewModel: <#Binding<LocationViewModel>#>, DriveDetail: DriveDetails(Locations: []))
//    }
//}
