//
//  UserStats.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI

struct UserStats: View {
	@State var DistanceTraveled: Measurement<UnitLength>
	@State var TimeTraveled: TimeInterval
    var body: some View {
		Group {
			VStack {
				Group {
					Image(systemName: "car.fill")
						.imageScale(.large)
						.font(.system(size: 100))
					Text("Your Total Driving Stats")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.multilineTextAlignment(.leading)
						.padding(.all)
				}
				.foregroundColor(Color(.systemTeal))
				.padding(.all)
				HStack {
					Text("Distance Driven").padding(.all)
					Spacer()
					Text(MeasurementFormatter().string(from: DistanceTraveled)).padding(.all)
				}
				HStack {
					Text("Time Driven").padding(.all)
					Spacer()
					Text(TimeTraveled.stringFromTimeInterval()).padding(.all)
				}
				Spacer()
			}
		}
		
    }
}
struct UserStats_Previews: PreviewProvider {
    static var previews: some View {
		UserStats(DistanceTraveled: Measurement(
					value: 4000,
					unit: UnitLength.meters),
				  TimeTraveled: Date().distance(to: Date()))
    }
}
