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
	@StateObject var locationViewModel = LocationViewModel()
    @Environment(\.managedObjectContext) private var viewContext
	
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: true)],
        animation: .default
	)
    private var items: FetchedResults<Item>

	@State var Recording = false
	@State var AllDrives: [DriveDetails] = []
	
	let locationManager = CLLocationManager()
	
	var body: some View {
		Group {
			VStack {
				if (Recording) {
					TrackingView(locationViewModel: locationViewModel)
						.onAppear(perform: {
							print("appeared recording")
						})
				} else {
					List {
						ForEach(0..<items.count, content: {i in
							Drive(locationViewModel: locationViewModel, driveDetail: items[i].location?.driveDetail)
						})
					}
					.onAppear(perform: {
						print("appeared list", items.first?.date as Any)
					})
				}
				HStack {
					ToolBar(Recording: $Recording, StartRecording: startRecording, StopRecording: stopRecording)
				}
			}
		}
		.onAppear(perform: {
			locationViewModel.requestPermission()
		})
	}
    private func startRecording() {
		if CLLocationManager.locationServicesEnabled() {
			locationViewModel.locationManager.activityType = .automotiveNavigation
			locationViewModel.locationManager.startUpdatingLocation()
		} else {
			print("location denied")
		}
    }
	
	private func stopRecording() {
		if CLLocationManager.locationServicesEnabled() {
			
			
			locationViewModel.locationManager.stopUpdatingLocation()
			let allLocations = locationViewModel.allLocations
			let newDrive = locationDelist(locations: allLocations, date: allLocations.first?.timestamp ?? Date())
			
			let newItem = Item(context: viewContext)
			newItem.location = newDrive
			newItem.date = (allLocations.first?.timestamp ?? Date())
			
			print(
				"hasChanges:", viewContext.hasChanges,
				"\ninsertedObjects:", viewContext.insertedObjects
			)
			viewContext.userInfo.setValue("data", forKey: "use")
			
			do {
				try viewContext.save()
			} catch {
				// Replace this implementation with code to handle the error appropriately.
				// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				let nsError = error as NSError
				print("error", error)
//				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
			}
			locationViewModel.allLocations = []
		} else {
			print("location denied")
		}
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
