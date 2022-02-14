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

	@State var distString: String = ""
	@State var totalString: String = ""
	@State var totalNum: TimeInterval?
	@State var nightString: String = ""
	@State var nightNum: TimeInterval?
	@State var description: String = ""
	//FIXME: TotalMarkerDistance needs to update after view loads
	@State var TotalMarkerDistance: Double = 0.0
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
	@State var badges: [DriveDetails.Badge]? = nil
	
	@State var Distance: Measurement<UnitLength> = Measurement.init(value: 0.0, unit: UnitLength.meters)
	
	func GetTimeInterval() -> String {
		return realDriveDetail.TotalDayTime.stringFromTimeInterval(isApptx: !isDriving)
	}

	func reloadDataAsync(realDriveDetail: DriveDetails, locationViewModel: LocationViewModel, distFormatter: MeasurementFormatter) async -> (Double, String,String,String, [DriveDetails.Badge], TimeInterval, TimeInterval, String)  {
		let nightTimeHolder = realDriveDetail.TotalNightTime
		let nightStringHolder = nightTimeHolder.stringFromTimeInterval()
		
		let TotalMarkerDistanceHolder = (driveDetail == nil) ? locationViewModel.driveDetail.GetDriveDistance().1 : driveDetail!.CoreDistance
		let distStringHolder = distFormatter.string(from: Measurement(value: TotalMarkerDistanceHolder, unit: UnitLength.meters))
		
		let totalTimeHolder = realDriveDetail.TotalDayTime
		let totalStringHolder = totalTimeHolder.stringFromTimeInterval()
		
		let badgesHolder = realDriveDetail.Badges()
		
		let descriptionHolder = shortItemFormatter.string(from: realDriveDetail.StartDate)
		
		return (TotalMarkerDistanceHolder, nightStringHolder, distStringHolder, totalStringHolder, badgesHolder, totalTimeHolder, nightTimeHolder, descriptionHolder)
	}
	var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
	@State private var SpeedTimer = Timer.publish(every: 0.1, tolerance: 0.05, on: .current, in: .default).autoconnect()
	var body: some View {
		ScrollView {
			VStack {
				VStack {
					if isDriving {
						MapView(driveDetails: realDriveDetail, isDriving: true)
							.frame(height: 400)
					} else {
						MapView(driveDetails: realDriveDetail, isDriving: false)
							.frame(height: 200)
					}
				}
				ZStack {
					Circle()
						.scale(1.5)
						.fill(UIColor.systemBackground.color)
						.shadow(radius: 5)
					Image(systemName: realDriveDetail.weather.Icon())
						.renderingMode(.original)
						.padding(.all, 5.0)
						.imageScale(.large)
						.font(.title)
						.shadow(radius: 2, x: 1, y: 1)
				}
				.offset(x: 0, y: -35)
				LazyVGrid(columns: columns) {
					if isDriving {
						BigStat(icon: "point.topleft.down.curvedto.point.filled.bottomright.up", text: "Distance", value: $distString, placeholderRedacted: "5.00 miles")
							.multilineTextAlignment(.trailing)
							.onReceive(SpeedTimer, perform: { _ in
								distString = distFormatter.string(from: Measurement(value: PredictedDistance, unit: UnitLength.meters))
							})
							.font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
							.foregroundColor(Color(UIColor.systemGreen))
					} else {
						BigStat(icon: "point.topleft.down.curvedto.point.filled.bottomright.up", text: "Distance", value: $distString, placeholderRedacted: "5.00 miles")
							.foregroundColor(Color(UIColor.systemGreen))
					}
					if (totalNum != 0.0) {
						BigStat(icon: "sun.max.fill", text: "Day Driving", value: $totalString)
							.foregroundColor(Color(UIColor.systemOrange))
					}
					if (nightNum != 0.0) {
						BigStat(icon: "moon.stars.fill", text: "Night Driving", value: $nightString)
							.foregroundColor(Color(UIColor.systemBlue))
					}
					if (realDriveDetail.notes != "") {
						NotesView(notes: realDriveDetail.notes)
					}
				}
				.padding()
				.offset(x: 0, y: -35)
				
//				Text("Speed Graph")
//					.font(.headline)
//					.fontWeight(.semibold)
//					.multilineTextAlignment(.leading)
//				HStack{
//					Graph(List: realDriveDetail.SpeedGraph(50))
//					VStack {
//						Text(String(Measurement(value: realDriveDetail.maxSpeed, unit: UnitSpeed.metersPerSecond).converted(to: .milesPerHour).value.rounded()) + " mph")
//							.font(.caption)
//							.fontWeight(.light)
//							.multilineTextAlignment(.trailing)
//							.lineLimit(1)
//						Spacer()
//						Text("0 mph")
//							.font(.caption)
//							.fontWeight(.light)
//					}
//					.padding()
//				}
//				.padding(.top)
//				.frame(height: 300.0)
				
			}
		}
		.task {
			let fullHolder = await reloadDataAsync(
				realDriveDetail: self.realDriveDetail,
				locationViewModel: locationViewModel,
				distFormatter: distFormatter
			)
			withAnimation(Animation.easeInOut(duration: 0.5)) {
				self.TotalMarkerDistance =  fullHolder.0
				self.nightString = fullHolder.1
				self.distString = fullHolder.2
				self.totalString = fullHolder.3
				self.badges = fullHolder.4
				self.totalNum = fullHolder.5
				self.nightNum = fullHolder.6
				self.description = fullHolder.7
			}
		}
		.navigationTitle(description)
	}
}

var lengthFormatter: LengthFormatter {
	let formatter = LengthFormatter()
	formatter.unitStyle = .long
	return formatter
}
