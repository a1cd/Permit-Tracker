//
//  DriveBadges.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/17/21.
//

import SwiftUI

struct DriveBadges: View {
	@State var Badges: [DriveDetails.Badge]
	var rows: [GridItem] =
		Array(repeating: GridItem(), count: 3)
    var body: some View {
		LazyHGrid(rows: rows) {
			ForEach(Badges, id: \.hashValue, content: {badge in
				Badge(icon: badge.icon)
			})
		}
    }
}

struct DriveBadges_Previews: PreviewProvider {
    static var previews: some View {
		DriveBadges(Badges: DriveDetails.Badge.Twilight.all)
    }
}

struct Badge: View {
	@Environment(\.colorScheme) var colorScheme
	@State var icon: (String, Bool, Color?)
	var body: some View {
		if (icon.1 || (colorScheme == .dark)) {
			Image(systemName: icon.0)
				.renderingMode(.original)
				.padding(.all, 1.5)
		} else {
			Image(systemName: icon.0)
				.padding(.all, 1.5)
				.foregroundColor(icon.2 ?? Color(UIColor.systemFill))
		}
	}
}
