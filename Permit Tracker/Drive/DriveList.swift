//
//  DriveList.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/13/21.
//

import SwiftUI
import CoreData

struct DriveList: View {
	@ObservedObject var locationViewModel: LocationViewModel
	
	@Environment(\.managedObjectContext) private var viewContext
	@Environment(\.editMode) var editMode
	@Environment(\.backgroundMaterial) var bckMat
	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: false)],
		animation: Animation.easeInOut
	)
	private var Drives: FetchedResults<Item>
	
	func deleteItems(_ offsets: IndexSet) -> Void {
		withAnimation(Animation.interactiveSpring()) {
			offsets.map { Drives[$0] }.forEach(viewContext.delete)
			do {
				try Task {
					try await viewContext.perform {
						try viewContext.save()
					}
				}
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				let nsError = error as NSError
				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
		}
	}
    var body: some View {
		NavigationView {
			List {
				ForEach(Drives ,id: \.date) {i in
					NavigationLink(
						destination:
							FullDriveData(
								locationViewModel: locationViewModel,
								driveDetail: DriveDetails(item: i)
							)
					) {
						Drive(
							locationViewModel: locationViewModel,
							driveDetail: DriveDetails(item: i),
							showMap: false
						)
					}
				}
				.onDelete(perform: deleteItems)
			}
			.navigationTitle("Driving History")
			.toolbar {EditButton()}
		}
    }
}
