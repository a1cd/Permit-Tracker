//
//  Stats.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/14/21.
//

import SwiftUI

struct Stats: View {
	@Binding var DistanceTraveled: Measurement<UnitLength>
	@Binding var TimeTraveled: TimeInterval
	@Binding var TotalNightTime: TimeInterval
	@Binding var AllDrives: [DriveDetails]
	
    var body: some View {
		ScrollView {
			VStack {
				UserStats(DistanceTraveled: $DistanceTraveled, TimeTraveled: $TimeTraveled, TotalNightTime: $TotalNightTime)
//				Graph(List: AllDrives.first?.SpeedGraph(16) ?? [])
			}
		}
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
		Stats(
			DistanceTraveled: .constant(Measurement(
				value: 4000,
				unit: UnitLength.meters)),
			TimeTraveled: .constant(Date().distance(to: Date())),
			TotalNightTime: .constant(19848),
			AllDrives: .constant([])
		)
    }
}
