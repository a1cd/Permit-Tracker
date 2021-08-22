//
//  Weather Description.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import SwiftUI

struct WeatherDescription: View {
	@State var Weather: Int
	func weatherFromInt(_ int: Int) -> Weather?{
		for i in allWeather {
			if i.rawValue == int {
				return i
			}
		}
		return nil
	}
    var body: some View {
		HStack {
			let weather = (weatherFromInt(Weather) ?? .Normal)
			WeatherIcon(isSelect: true, weather: weather)
			VStack{
				Text(weather.Description().text)
					.font(.title)
					.multilineTextAlignment(.center)
				Text(weather.Description().description)
					.multilineTextAlignment(.leading)
				if (weather).Description().link != nil {
					Link(weather.Description().linkText ?? "Link", destination: weather.Description().link!)
				}
			}
			.frame(width: 275)
		}
		.padding(.vertical, 3.0)
    }
}

struct WeatherDescription_Previews: PreviewProvider {
    static var previews: some View {
		WeatherDescription(Weather: 4)
    }
}
