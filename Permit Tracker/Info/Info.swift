//
//  Info.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 3/6/22.
//

import SwiftUI

struct Info: View {
    var body: some View {
		List {
			Label("Using location may dramatically decrease battery life.", systemImage: "battery.0")
		}
    }
}

struct Info_Previews: PreviewProvider {
    static var previews: some View {
        Info()
    }
}

