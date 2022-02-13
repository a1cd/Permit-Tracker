//
//  DriveList.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI
import CoreData

struct DriveList: View {
	
	var locationViewModel: LocationViewModel
	@Environment(\.managedObjectContext) private var viewContext
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: false)],
		animation: Animation.easeInOut
	)
	private var Drives: FetchedResults<Item>
	
	@State var tryingToDelete: Bool = false
	@State var deleteOffset: IndexSet? = nil
	
	func deleteItems(_ offsets: IndexSet) -> Void {
		withAnimation {
			offsets.map { Drives[$0] }.forEach(viewContext.delete)
			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
	
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
				ForEach(Drives,id: \.date) {i in
					if let locations = i.locations {
						if locations.count > 0 {
							NavigationLink(
								destination:
									FullDriveData(
										locationViewModel: locationViewModel,
										driveDetail: DriveDetails(item: i)
									)
							)
							{
								Drive(
									locationViewModel: locationViewModel,
									driveDetail: DriveDetails(item: i),
									showMap: false
								)
							}
						}
					}
				}
				.onDelete(perform: areYouSure)
				.alert(isPresented: $tryingToDelete, content: alert)
			}
			.navigationTitle("Driving History")
//			.listStyle(GroupedListStyle())
//		}
    }
}
