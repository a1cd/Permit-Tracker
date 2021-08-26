//
//  HomeView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/23/21.
//

import SwiftUI

struct HomeView: View {
	@Environment(\.colorScheme) var colorScheme
	
	@ObservedObject var locationViewModel: LocationViewModel
	var Drives: FetchedResults<Item>
	@Binding var AllDrives: [DriveDetails]
	
	let deleteItems: (_ offsets: IndexSet) -> Void
	
	func CalculateStats(AllDrives: [DriveDetails]) -> Measurement<UnitLength> {
		let main = DispatchQueue.main
		var totalDistance: Double = 0
		let newAllDrives = AllDrives
		let group = DispatchGroup()
		for drive in newAllDrives {
			DispatchQueue.global(qos: .userInitiated).async {
				let DriveLocationDistance: Double = 0
				if var lastLocation = drive.filteredLocations.first {
					for location in drive.filteredLocations {
						totalDistance += location.distance(from: lastLocation)
						lastLocation = location
					}
				}
				group.enter()
				main.async {
					totalDistance += DriveLocationDistance
					group.leave()
				}
			}
		}
		group.wait()
		return Measurement(value: totalDistance, unit: UnitLength.meters)
	}
	func CalculateNightDriving(AllDrives: [DriveDetails]) -> TimeInterval {
		var time: TimeInterval = 0
		for drive in AllDrives {
			time += drive.TotalNightTime
		}
		return time
	}
	func CalculateTotalTime(AllDrives: [DriveDetails]) -> TimeInterval {
		var totalTime: TimeInterval = TimeInterval()
		for drive in AllDrives {
			totalTime += drive.TimeInterval
		}
		return totalTime
	}
	
    var body: some View {
		NavigationView {
			ScrollView {
				UserStats(
					DistanceTraveled: CalculateStats,
					TimeTraveled: CalculateTotalTime,
					TotalNightTime: CalculateNightDriving,
					AllDrives: $AllDrives
				)
				.background(Color((colorScheme == ColorScheme.dark) ? UIColor.secondarySystemBackground : UIColor.systemBackground))
				.scaledToFit()
				.drawingGroup()
				
				.clipped()
				.cornerRadius(30)
				.shadow(radius: 2, x: 0, y: 2)
				.padding(.bottom, 3.5)
				Divider()
				// Drive list
				NavigationLink(destination: DriveList(locationViewModel: locationViewModel, AllDrives: $AllDrives, deleteItems: deleteItems)) {
					Image(systemName: "map")
						.padding(.leading)
						.imageScale(.large)
					Text("Drive History")
						.multilineTextAlignment(.leading)
						.padding(.trailing)
					Spacer()
				}
				.foregroundColor(.primary)
				Divider()
				// Stats
				NavigationLink(destination: Stats(DistanceTraveled: CalculateStats, TimeTraveled: CalculateTotalTime, TotalNightTime: CalculateNightDriving, AllDrives: $AllDrives)) {
					Image(systemName: "chart.bar")
						.padding(.leading)
						.imageScale(.large)
					Text("Stats")
						.multilineTextAlignment(.leading)
						.padding(.trailing)
					Spacer()
				}
				.foregroundColor(.primary)
				Spacer()
			}
		}
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//		HomeView(locationViewModel: <#LocationViewModel#>, Drives: <#FetchedResults<Item>#>, AllDrives: <#[DriveDetails]#>, deleteItems: <#(IndexSet) -> Void#>)
//    }
//}
