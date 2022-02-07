//
//  DebugDriveStatus.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/4/22.
//

import SwiftUI

struct DebugDriveStatus: View {
    var body: some View {
		List {
			Text(UserDefaults.standard.string(forKey: "failed") ?? "No errors")
			Text(UserDefaults.standard.string(forKey: "status") ??  "Nothing to show for location statuses")
		}
    }
}

struct DebugDriveStatus_Previews: PreviewProvider {
    static var previews: some View {
        DebugDriveStatus()
    }
}
