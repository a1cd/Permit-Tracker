//
//  Weather.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/19/21.
//

import SwiftUI

enum Weather: Int {
	case None = 0
	case Normal = 1
	case Rain = 2
	case Snow = 3
	case Hail = 4
	case Sleet = 5
	case FreezingRain = 6
	case Fog = 7
	func Color() -> Color? {
		switch self {
		case .None:
			return SwiftUI.Color.white
		default:
			return nil
		}
	}
	func Icon() -> String {
		switch self {
		case .None:
			return "questionmark.circle.fill"
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
		default:
			return "exclamationmark.triangle.fill"
		}
	}
	func Text() -> String {
		switch self {
		case .None:
			return "None"
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
		default:
			return "No weather? (Possible error)"
		}
	}
	func Description() -> Description {
		switch self {
		case .None:
			return .init("None", "No option selected")
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
let allWeather: [Weather] = [.Normal, .Rain, .Snow, .Hail, .Sleet, .FreezingRain, .Fog, .None]
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
					Button(action: {
						print("set Select to the raw value of: " + weather.Description().text + ". aka:", weather.rawValue)
						Select = weather.rawValue
						print("Select will be",_Select.projectedValue.wrappedValue)
						print("Select is now",Select)
					}, label: {
						WeatherIcon(isSelect: weather.rawValue == Select, weather: weather)
					})
					
				})
			}
			.frame(height: 135.0)
			.scaledToFit()
			WeatherDescription(Weather: Select)
				.padding()
			Text(String(Select))
		}
    }
}

struct WeatherChoice_Previews: PreviewProvider {
	
    static var previews: some View {
		VStack {
			Spacer()
			WeatherChoice(Select: .constant(0))
			Spacer()
		}
    }
}
