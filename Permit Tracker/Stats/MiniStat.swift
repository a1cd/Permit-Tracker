//
//  MiniStat.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/11/22.
//

import SwiftUI

struct MiniStat: View {
	@State var icon: String
	@State var text: String
	@Binding var value: String
	@State var placeholderRedacted: String = "0.0m"
	var body: some View {
		VStack(alignment: .center) {
			Label(text, systemImage: icon)
				.labelStyle(IconOnlyLabelStyle())
//			Spacer()
//				.transition(.scale.animation(Animation.easeInOut))
				
			if (value == "") {
				Text(placeholderRedacted)
					.scaledToFill()
					.redacted(reason: .placeholder)
					.multilineTextAlignment(.trailing)
			} else {
				Text(value)
					.scaledToFill()
					.multilineTextAlignment(.trailing)
			}
		}
	}
}

struct MiniStat_Previews: PreviewProvider {
    static var previews: some View {
		MiniStat(icon: "ruler", text: "Text", value: .constant("3000-value"))
			.padding()
    }
}
