//
//  DebugDriveStatus.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/4/22.
//

import SwiftUI

struct DebugDriveStatus: View {
	@Environment(\.managedObjectContext) private var viewContext
	
    var body: some View {
		List {
			Text(UserDefaults.standard.string(forKey: "failed") ?? "No errors")
			Text(UserDefaults.standard.string(forKey: "status") ??  "Nothing to show for location statuses")
			Button(action: {
				do {
					try viewContext.save()
					print("Saved")
				} catch  {
					print("Cannot Save")
				}
			}, label: {
				HStack{
					Image(systemName: "arrow.triangle.2.circlepath.circle")
					Text("Save")
				}
			})
		}
    }
}

struct DebugDriveStatus_Previews: PreviewProvider {
    static var previews: some View {
        DebugDriveStatus()
    }
}
