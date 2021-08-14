//
//  Stat.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI

struct Stat: View {
	@State var Name: String
	@State var Icon: String?
	@State var Value: String?
	@State var ValueIcon: String?
	@State var ValueView: some View = EmptyView().unredacted()
    var body: some View {
		HStack {
			if ((Icon) != nil) {
				Image(systemName: Icon!)
					.padding([.top, .leading, .bottom])
					.imageScale(.large)
					.scaleEffect(1.25)
					.font(Font.title.weight(.bold))
			}
			Text(Name)
				.font(.title)
				.padding([.top, .leading, .bottom])
			Spacer()
			if (Value != nil) {
				Text(Value!)
					.font(.headline)
					.padding(.all)
			}
			if (ValueIcon != nil) {
				Text(ValueIcon!)
					.padding(.all)
			}
			if (ValueView != nil) {
				ValueView()
			}
		}
    }
}

struct Stat_Previews: PreviewProvider {
    static var previews: some View {
		Stat(Name: "Stat", Icon: "number.circle.fill", Value: "Stat Value")
    }
}
