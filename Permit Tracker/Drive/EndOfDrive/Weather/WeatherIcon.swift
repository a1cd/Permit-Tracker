//
//  WeatherIcon.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/20/21.
//

import SwiftUI

struct WeatherIcon: View {
	@State var isSelect: Bool = false
	@State var weather: Weather
    var body: some View {
		Group {
			Image(systemName: weather.Icon())
				.renderingMode(.original)
				.padding(.all, 5.0)
				.imageScale(.large)
				.font(.title)
				.shadow(radius: 2, x: 1, y: 1)
		}
		.frame(width: 65, height: 65)
		.background(Color(isSelect ? UIColor.link : UIColor.systemGray2))
		.cornerRadius(10)
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
		WeatherIcon(isSelect: false ,weather: .Rain)
    }
}
