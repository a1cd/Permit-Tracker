//
//  WeatherView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import SwiftUI

struct WeatherView: View {
	@State var Weather: Weather
    var body: some View {
		GroupBox(label: Text("Weather"), content: {
			HStack {
				VStack(alignment: .leading) {
					HStack(alignment: .top) {
						WeatherIcon(isSelect: false, weather: Weather)
						Text(Weather.Description().text)
							.font(.title2)
							.padding(.leading)
					}
					.padding()
				}
				.scaledToFill()
				Spacer()
			}
		})
		.padding()
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
		WeatherView(Weather: .Rain)
    }
}
