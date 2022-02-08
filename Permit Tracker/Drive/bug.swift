//
//  Drive.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit

struct Bug: View {
	var body: some View {
		GroupBox(label: Text("label")) {
			VStack {
				HStack {
					Spacer()
					Text("Stuff")
				}
				.padding(.horizontal)
				if true {
					if false {
						Text("hi")
							.frame(height: 400)
					} else {
						Text("bye")
							.frame(height: 200)
					}
				}
				HStack {
					Image(systemName: "ruler")
					Text("Distance")
					Spacer()
					if false {
						Text("hi")
							.font(.system(Font.TextStyle.body, design: Font.Design.monospaced))
					} else {
						Text("300 meters")
					}
				}
				.foregroundColor(Color(UIColor.systemGreen))
				HStack {
					Image(systemName: "sun.max.fill")
					Text("Day Driving")
					Spacer()
					Text("3 days! wow")
				}
				.foregroundColor(Color(UIColor.systemOrange))
				Text("More Text")
				.foregroundColor(Color(UIColor.systemBlue))
			}
		}
	}
}
