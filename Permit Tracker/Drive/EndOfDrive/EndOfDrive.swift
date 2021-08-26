//
//  EndOfDrive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/19/21.
//

import SwiftUI

struct EndOfDrive: View {
	@Binding var working: Bool
	@Binding var weather: Int
	@Binding var notes: String
	@Binding var Supervisor: String
	@StateObject var locationViewModel: LocationViewModel
    var body: some View {
		VStack {
			Group {
				Text("Weather")
					.font(.largeTitle)
					.multilineTextAlignment(.leading)
				WeatherChoice(Select: _weather)
			}
			Divider()
			Group {
				Text("Supervisor Initial")
					.font(.largeTitle)
					.multilineTextAlignment(.leading)
				TextField("Supervisor Initial", text: $Supervisor)
					.textFieldStyle(RoundedBorderTextFieldStyle())
			}
			Group {
				Text("Notes")
					.font(.largeTitle)
					.multilineTextAlignment(.leading)
				DrivingNotes(fullText: $notes)
			}
			Button(action: {
				working = false
				print("Working: ", working)
				print("Projected Working:", _working.projectedValue.wrappedValue)
			}, label: {
				Text("Done")
					.font(.title2)
					.fontWeight(.semibold)
					.foregroundColor(Color(UIColor.lightText))
					.padding(6.0)
					.padding(.horizontal, 7.0)
			})
			.background(Color(UIColor.systemBlue))
			.cornerRadius(10)
		}
    }
}

struct EndOfDrive_Previews: PreviewProvider {
    static var previews: some View {
		EndOfDrive(working: .constant(true), weather: .constant(3), notes: .constant("Pretty bad driving, swerved a LOT!"), Supervisor: .constant("Dad"))
    }
}
