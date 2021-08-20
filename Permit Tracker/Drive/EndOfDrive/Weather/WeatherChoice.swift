//
//  Weather.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/19/21.
//

import SwiftUI

enum Weather: Int {
	case Normal = 0
	case Rain = 1
	case Snow = 2
	case Hail = 3
	case Sleet = 4
	case FreezingRain = 5
	case Fog = 6
	func Icon() -> String {
		switch self {
		case .Normal:
			return "sun.max.fill"
		case .Rain:
			return "cloud.rain.fill"
		case .Snow:
			return "snow"
		case .Hail:
			return "cloud.hail.fill"
		case .Sleet:
			return "cloud.sleet.fill"
		case .FreezingRain:
			return "thermometer.snowflake"
		case .Fog:
			return "cloud.fog.fill"
		}
		return "exclamationmark.triangle.fill"
	}
	func Text() -> String {
		switch self {
		case .Normal:
			return "Normal"
		case .Rain:
			return "Rain"
		case .Snow:
			return "Snow"
		case .Hail:
			return "Hail"
		case .Sleet:
			return "Sleet"
		case .FreezingRain:
			return "Freezing Rain"
		case .Fog:
			return "Fog"
		}
		return "No weather? (Possible error)"
	}
	func Description() -> Description {
		switch self {
		case .Normal:
			return .init("Normal",
						 "For normal weather: cloudy, sunny, etc.")
		case .Rain:
			return .init("Rain",
						 "If it rained or there was a noticable amount of (large) puddles on the roadway",
						 URL(string: "https://exchange.aaa.com/safety/driving-advice/wet-weather-driving-tips/"),
						 "Wet Weather Driving Tips (AAA)")
		case .Snow:
			return .init("Snow",
						 "If it was snowing or there was snow on the ground.",
						 URL(string: "https://exchange.aaa.com/safety/driving-advice/winter-driving-tips/"),
						 "Winter Driving Tips (AAA)")
		case .Hail:
			return .init("Hail",
						 "Balls of ice, falls like rain. larger than 5mm \nDo not drive with hail. \nIf it is going to hail, protect your car.",
						 URL(string: "https://exchange.aaa.com/safety/driving-advice/winter-driving-tips/"),
						 "Winter Driving Tips (AAA)")
		case .Sleet:
			return .init("Sleet",
						 "Small balls of ice that fall like snow. These are usually smaller than 5mm and can be dangerous to drive with. If you must drive with ice or sleet, drive SLOW.",
						 URL(string: "https://exchange.aaa.com/safety/driving-advice/winter-driving-tips/"),
						 "Winter Driving Tips (AAA)")
		case .FreezingRain:
			return .init("Freezing Rain",
						 "This is rain that freezes when it hits the ground. \nSTRONGLY AVOID! \nDo not drive if there is, or recently was, freezing rain.",
						 URL(string: "https://exchange.aaa.com/safety/driving-advice/winter-driving-tips/"),
						 "Winter Driving Tips (AAA)")
		case .Fog:
			return .init("Fog",
						 "Avoid if possible! Fog can reduce your visablility greatly. \nNever use high-beams and slow down! \nIncrease distance from other vehicles")
		}
		return .init("None", "No weather? (Possible error)")
	}
}
let allWeather: [Weather] = [.Normal, .Rain, .Snow, .Hail, .Sleet, .FreezingRain, .Fog]
struct WeatherChoice: View {
	@Binding var Select: Int
	private var item: GridItem {
		var item = GridItem()
		item.spacing = 5
		return item
	}
    var body: some View {
		VStack {
			LazyHGrid(rows: [item, item]) {
				ForEach(allWeather, id: \.rawValue, content: {weather in
					let isSelect = (weather.rawValue == Select)
					WeatherIcon(isSelect: isSelect, weather: weather)
					.onTapGesture {
						Select = weather.rawValue
					}
					
				})
			}
			.frame(height: 135.0)
			.scaledToFit()
			WeatherDescription(Weather: Select)
				.padding()
		}
    }
}

struct WeatherChoice_Previews: PreviewProvider {
	
    static var previews: some View {
		VStack {
			Spacer()
			WeatherChoice(Select: .constant(6))
			Spacer()
		}
    }
}
