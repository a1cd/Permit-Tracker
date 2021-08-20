//
//  EndOfDrive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/19/21.
//

import SwiftUI

struct EndOfDrive: View {
	@Binding var working: Bool
	@State var Weather: Int = 0
    var body: some View {
		VStack {
			GroupBox(label: Text("Weather").font(.largeTitle), content: {
				WeatherChoice(Select: $Weather)
			})
		}
    }
}

struct EndOfDrive_Previews: PreviewProvider {
    static var previews: some View {
		EndOfDrive(working: .constant(true))
    }
}
