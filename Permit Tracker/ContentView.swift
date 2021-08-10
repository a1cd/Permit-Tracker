//
//  ContentView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import CoreData
import CoreLocation
import BackgroundTasks

struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
	let locationManager = CLLocationManager()
	
    var body: some View {
        List {
			ForEach(0..<3) { num in
				Drive(driveDetails: DriveDetails(Date: Date(), Interval: Date().distance(to: Date()), locations: []))
            }
//            .onDelete(perform: deleteItems)
        }
        .toolbar {
			ToolbarItem(placement: .bottomBar) {
				Button(action: startRecording) {
					Label("Record", systemImage: "record.circle")
				}
			}
			
        }
    }
//	private func addItem() {
//		withAnimation {
//			let newItem = Item(context: viewContext)
//			newItem.timestamp = Date()
//
//			do {
//				try viewContext.save()
//			} catch {
//				// Replace this implementation with code to handle the error appropriately.
//				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				let nsError = error as NSError
//				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//			}
//		}
//	}
//
    private func startRecording() {
		
		// Ask for Authorisation from the User.
		self.locationManager.requestAlwaysAuthorization()

		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
			locationManager.startUpdatingLocation()
		}
//		task
    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
	
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
