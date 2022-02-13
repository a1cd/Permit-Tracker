//
//  UserStats.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI

struct UserStats: View {
	@Binding var DistanceTraveled: Measurement<UnitLength>
	@Binding var TimeTraveled: TimeInterval
	@Binding var TotalNightTime: TimeInterval
	
	@State var timeGagues: Array<GagueSlice> = []
	@State var nightGagues: Array<GagueSlice> = []
	@State var withIcon: Bool = true
	@State var iconSize: CGFloat = 80
	
	func getGagues(TimeTraveled: TimeInterval, TotalNightTime: TimeInterval) async -> ([GagueSlice], [GagueSlice]) {
		return (
			[GagueSlice(lineWidth: 10, color: Color(UIColor.systemOrange), start: 0, end: CGFloat(TimeTraveled/(50*60*60)), level: 2)],
			[GagueSlice(lineWidth: 10, color: Color(UIColor.systemBlue), start: 0, end: CGFloat(TotalNightTime/(10*60*60)), level: 2)]
		)
	}
    var body: some View {
		Group {
			VStack {
				Group {
					if withIcon {
						Image(systemName: "car.fill")
							.padding([.top, .leading, .trailing])
							.imageScale(.large)
							.font(.system(size: iconSize))
					}
					Text("Your Driving Stats")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.multilineTextAlignment(.leading)
						.padding([.leading, .bottom, .trailing])
				}
				.foregroundColor(Color(.systemTeal))
				VStack {
					HStack {
						Image(systemName: "ruler.fill")
							.frame(width: 50.0, height: 50.0)
						Text("Distance Driven").padding(.all)
						Spacer()
						Text(MeasurementFormatter().string(from: DistanceTraveled)).padding(.all)
					}
					.padding(.bottom, 5.0)
					.foregroundColor(.init(UIColor.systemGreen))
					HStack {
						ZStack {
							GagueView(BaseGague: .init(lineWidth: 10, color: .init(UIColor.systemOrange), opacity: 0.3, level: 2), Gagues: $timeGagues)
								.frame(width: 50.0, height: 50.0)
							Image(systemName: "stopwatch.fill")
								.frame(width: 50.0, height: 50.0)
						}
						Text("Time Driven").padding(.all)
						Spacer()
						Text(TimeTraveled.stringFromTimeInterval()).padding(.all)
					}
					.padding(.bottom, 5.0)
					.foregroundColor(.init(UIColor.systemOrange))
					HStack {
						ZStack {
							GagueView(BaseGague: .init(lineWidth: 10, color: .init(UIColor.systemBlue), opacity: 0.3, level: 2), Gagues: $nightGagues)
								.frame(width: 50.0, height: 50.0)
							Image(systemName: "moon.stars.fill")
								.frame(width: 50.0, height: 50.0)
						}
						Text("Night Driving").padding(.all)
						Spacer()
						Text(TotalNightTime.stringFromTimeInterval()).padding(.all)
					}
					.foregroundColor(.init(UIColor.systemBlue))
				}
				.padding(.all)
			}
		}
		.onChange(of: TotalNightTime+TimeTraveled) { _ in
			Task {
				let Gagues = await getGagues(TimeTraveled: TimeTraveled, TotalNightTime: TotalNightTime)
				withAnimation {
					timeGagues = Gagues.0
					nightGagues = Gagues.1
				}
			}
		}
		.task {
			let Gagues = await getGagues(TimeTraveled: TimeTraveled, TotalNightTime: TotalNightTime)
			withAnimation {
				timeGagues = Gagues.0
				nightGagues = Gagues.1
			}
		}
    }
}
struct UserStats_Previews: PreviewProvider {
    static var previews: some View {
		UserStats(
			DistanceTraveled: .constant(Measurement(
				value: 124.58,
				unit: UnitLength.miles)),
			TimeTraveled: .constant(8881),
			TotalNightTime: .constant(5*60*60)
		)
    }
}
