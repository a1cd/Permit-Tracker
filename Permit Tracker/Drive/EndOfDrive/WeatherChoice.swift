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
		default:
			return "exclamationmark.triangle.fill"
		}
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
		default:
			return "No weather? (Possible error)"
		}
	}
	func Description() -> String {
		switch self {
		case .Normal:
			return "For normal weather: cloudy, sunny, etc."
		case .Rain:
			return "If it rained or there was a noticable amount of (large) puddles on the roadway"
		case .Snow:
			return "It was snowing or there was snow on the ground."
		case .Hail:
			return "Little balls of ice fell from the sky. These can damage your car if they are too big!"
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
		LazyHGrid(rows: [item, item]) {
			ForEach(allWeather, id: \.rawValue, content: {weather in
				let isSelect = (weather.rawValue == Select)
				Group {
					Image(systemName: weather.Icon())
						.renderingMode(.original)
						.padding(.all, 5.0)
						.imageScale(.large)
						.font(.title)
						.shadow(radius: 2, x: 1, y: 1)
				}
				.frame(width: 65, height: 65)
				.background(Color(isSelect ?  UIColor.systemBlue : UIColor.systemGray2))
				.cornerRadius(10)
				.onTapGesture {
					Select = weather.rawValue
				}
				
			})
		}
		.frame(height: 135.0)
		.scaledToFit()
    }
}

struct WeatherChoice_Previews: PreviewProvider {
	
    static var previews: some View {
		VStack {
			Spacer()
			WeatherChoice(Select: .constant(2))
			Spacer()
		}
    }
}
