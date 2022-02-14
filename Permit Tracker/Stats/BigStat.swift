//
//  BigStat.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/13/22.
//

import SwiftUI

struct BigStat: View {
	@State var icon: String
	@State var text: String
	@Binding var value: String
	@State var placeholderRedacted: String = "0.0m"
    var body: some View {
		if (value != "") {
			GroupBox( content: {
				Text(value)
					.font(.title2)
					.fontWeight(.semibold)
					.scaledToFill()
					.multilineTextAlignment(.trailing)
			}, label: {
				Label(text, systemImage: icon)
					.labelStyle(TitleAndIconLabelStyle())
			})
				.scaledToFill()
		} else {
			GroupBox( content: {
				Text(value)
					.font(.title2)
					.fontWeight(.semibold)
					.scaledToFill()
					.multilineTextAlignment(.trailing)
			}, label: {
				Label(text, systemImage: icon)
					.labelStyle(TitleAndIconLabelStyle())
			})
				.scaledToFill()
				.redacted(reason: .placeholder)
		}
	}
}

struct BigStat_Previews: PreviewProvider {
    static var previews: some View {
		BigStat(icon: "car", text: "A Car", value: .constant("32"))
			.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			.frame(width: 150, height: 150)
    }
}
