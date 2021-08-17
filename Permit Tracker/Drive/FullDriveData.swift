//
//  FullDriveData.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit

struct FullDriveData: View {
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
	
	@State private var Distance: Measurement<UnitLength> = Measurement.init(value: 0, unit: UnitLength.meters)
	
	func GetTimeInterval() -> String {
		if (isDriving) {
			return realDriveDetail.TimeInterval.stringFromTimeInterval(isApptx: !isDriving)
		} else {
			// dont show while driving because location refresh is not exactly 1 second
			return realDriveDetail.TimeInterval.stringFromTimeInterval(isApptx: !isDriving)
		}
	}
	
	@State private var SpeedTimer = Timer.publish(every: 0.1, tolerance: 0.05, on: .current, in: .default).autoconnect()
	var body: some View {
		ScrollView {
			VStack {
				GroupBox(label: label) {
					VStack {
						if isDriving {
							MapView(driveDetails: realDriveDetail, isDriving: true)
								.frame(height: 400)
						} else {
							MapView(driveDetails: realDriveDetail, isDriving: false)
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
						HStack {
							Image(systemName: "moon.stars.fill")
							Text("Night Driving")
							Spacer()
							Text(realDriveDetail.TotalNightTime.stringFromTimeInterval())
						}
					}
				}
				Text("Speed Graph")
					.font(.headline)
					.fontWeight(.semibold)
					.multilineTextAlignment(.leading)
				HStack{
					Graph(List: realDriveDetail.SpeedGraph(50))
					VStack {
						Text(String(Measurement(value: realDriveDetail.maxSpeed, unit: UnitSpeed.metersPerSecond).converted(to: .milesPerHour).value.rounded()) + " mph")
							.font(.caption)
							.fontWeight(.light)
							.multilineTextAlignment(.trailing)
							.lineLimit(1)
						Spacer()
						Text("0 mph")
							.font(.caption)
							.fontWeight(.light)
					}
					.padding()
				}
				.padding(.top)
				.frame(height: 300.0)
				
			}
		}
	}
}

var lengthFormatter: LengthFormatter {
	let formatter = LengthFormatter()
	formatter.unitStyle = .long
	return formatter
}
