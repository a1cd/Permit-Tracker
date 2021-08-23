//
//  DriveList.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI

struct DriveList: View {
	
	var locationViewModel: LocationViewModel
	var Drives: FetchedResults<Item>
	
	@State var tryingToDelete: Bool = false
	@State var deleteOffset: IndexSet? = nil
	
	let deleteItems: (_ offsets: IndexSet) -> Void
	
	func userIsSureOkToDelete() {
		if deleteOffset != nil {
			deleteItems(deleteOffset!)
		}
	}
	
	func areYouSure(_ offsets: IndexSet) {
		tryingToDelete = true
		deleteOffset = offsets
	}
	
	func alert() -> Alert {
		return Alert(
			title: Text("Are you sure?"),
			message: Text("Are you sure you want to delete this drive?\n") + Text("You cannot undo this action.").foregroundColor(Color(UIColor.systemRed)),
			primaryButton: Alert.Button.cancel({tryingToDelete = false}),
			secondaryButton: Alert.Button.destructive(Text("Delete"), action: userIsSureOkToDelete)
		)
	}
	
    var body: some View {
//		NavigationView {
			List {
				ForEach(0..<Drives.count, content: {i in
					if Drives[i].locations != nil {
						if (Drives[i].locations?.count ?? 0) > 0 {
							NavigationLink(
								destination:
									FullDriveData(
										locationViewModel: locationViewModel,
										driveDetail: DriveDetails(item: Drives[i])
									)
							)
							{
								Drive(
									locationViewModel: locationViewModel,
									driveDetail: DriveDetails(item: Drives[i]),
									showMap: i < 2
								)
							}
						}
					}
				})
				.onDelete(perform: areYouSure)
				.alert(isPresented: $tryingToDelete, content: alert)
			}
			.navigationTitle("Driving History")
//			.listStyle(GroupedListStyle())
//		}
    }
}
