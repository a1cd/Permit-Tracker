//
//  Stats.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

struct Stats: View {
	var DistanceTraveled: (_: [DriveDetails]) -> Measurement<UnitLength>
	var TimeTraveled: (_: [DriveDetails]) -> TimeInterval
	var TotalNightTime: (_: [DriveDetails]) -> TimeInterval
	@Binding var AllDrives: [DriveDetails]
	
    var body: some View {
		ScrollView {
			VStack {
				UserStats(DistanceTraveled: DistanceTraveled, TimeTraveled: TimeTraveled, TotalNightTime: TotalNightTime, AllDrives: $AllDrives)
				Graph(List: AllDrives.first?.SpeedGraph(16) ?? [])
			}
		}
    }
}

//struct Stats_Previews: PreviewProvider {
//    static var previews: some View {
//		Stats(
//			DistanceTraveled: Measurement(
//				value: 4000,
//				unit: UnitLength.meters),
//			TimeTraveled: Date().distance(to: Date()),
//			TotalNightTime: 19848,
//			AllDrives: []
//		)
//    }
//}
