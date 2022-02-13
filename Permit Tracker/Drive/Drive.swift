//
//  Drive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit

struct Drive: View {
	@Environment(\.colorScheme) var colorScheme
	@ObservedObject var locationViewModel: LocationViewModel
	
	@State var driveDetail: DriveDetails?
	
	@State var showMap: Bool = true
	
	var realDriveDetail: DriveDetails {
		if (driveDetail == nil) {
			return locationViewModel.driveDetail
		} else {
			return driveDetail!
		}
	}
	@State var distString: String = ""
	@State var totalString: String = ""
	@State var nightString: String = ""
	var label: some View {
		if (driveDetail == nil) {
			return Text("Your drive \(itemFormatter.string(from: locationViewModel.driveDetail.StartDate))")
		} else {
			return Text("Your drive \(itemFormatter.string(from: driveDetail!.StartDate))")
		}
	}
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
	
	@State var SpeedTimer = Timer.publish(every: 0.1, tolerance: 0.05, on: .current, in: .default).autoconnect()
	@State var SecondTimer = Timer.publish(every: 0.1, tolerance: 0.05, on: .current, in: .default).autoconnect()
	func reloadDataAsync(realDriveDetail: DriveDetails, locationViewModel: LocationViewModel, distFormatter: MeasurementFormatter) async -> (Double, String,String,String, [DriveDetails.Badge])  {
		let nightStringHolder = realDriveDetail.TotalNightTime.stringFromTimeInterval()
		
		let TotalMarkerDistanceHolder = (driveDetail == nil) ? locationViewModel.driveDetail.GetDriveDistance().1 : driveDetail!.CoreDistance
		let distStringHolder = distFormatter.string(from: Measurement(value: TotalMarkerDistanceHolder, unit: UnitLength.meters))
		
		let totalStringHolder = realDriveDetail.TotalDayTime.stringFromTimeInterval()
		
		let badgesHolder = realDriveDetail.Badges()
		
		return (TotalMarkerDistanceHolder, nightStringHolder, distStringHolder, totalStringHolder, badgesHolder)
	}
	
	var body: some View {
		GroupBox(label: label) {
			VStack {
				HStack {
					if (badges == nil ) {
						Spacer()
						ForEach(0..<2) {_ in
							Badge(icon: DriveDetails.Badge.Day.icon)
								.cornerRadius(100)
								.redacted(reason: .placeholder)
						}
					} else {
						Spacer()
						ForEach(badges!) {i in
							Badge(icon: i.icon)
						}
					}
				}
				.padding(.horizontal)
				.task {

				}
				if showMap {
					if isDriving {
						MapView(driveDetails: locationViewModel.driveDetail, isDriving: true)
							.frame(height: UIScreen.main.coordinateSpace.bounds.height/2)
					} else {
//						MapView(driveDetails: driveDetail!, isDriving: false)
//							.frame(height: 200)
						EmptyView()
					}
				}
				HStack {
					if isDriving {
						Image(systemName: "ruler")
						Text("Distance")
						Spacer()
						Text(distString)
							.multilineTextAlignment(.trailing)
							.onReceive(SpeedTimer, perform: { _ in
								distString = distFormatter.string(from: Measurement(value: PredictedDistance, unit: UnitLength.meters))
							})
							.font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
					} else {
						MiniStat(icon: "ruler", text: "Distance", value: $distString, placeholderRedacted: "5.00 miles")
					}
				}
				.foregroundColor(Color(UIColor.systemGreen))
				MiniStat(icon: "sun.max.fill", text: "Day Driving", value: $totalString)
				.foregroundColor(Color(UIColor.systemOrange))
				MiniStat(icon: "moon.stars.fill", text: "Night Driving", value: $nightString)
//				.onReceive(SecondTimer, perform: { _ in
//					if isDriving {
//						locationViewModel.driveDetail.TotalNightTime = locationViewModel.driveDetail.getTotalNightTime()
//					}
//				})
				.foregroundColor(Color(UIColor.systemBlue))
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

func TimeIntervalFrom(Days: Double = 0, Hours: Double = 0, Minuites: Double = 0, Seconds: Double = 0) -> TimeInterval {
	var interval: TimeInterval = TimeInterval()
	interval += Days
	interval *= 24
	
	interval += Hours
	interval *= 60
	
	interval += Minuites
	interval *= 60
	
	interval += Seconds
	interval *= 60
	
	return interval
}

//struct Drive_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
