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
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
	let locationManager = CLLocationManager()
	
	var body: some View {
		switch locationViewModel.authorizationStatus {
		case .notDetermined:
			AnyView(RequestLocationView())
				.environmentObject(locationViewModel)
		case .restricted:
			ErrorView(errorText: "Location use is restricted.")
		case .denied:
			ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
		case .authorizedAlways, .authorizedWhenInUse:
			TrackingView()
				.environmentObject(locationViewModel)
		default:
			Text("Unexpected status")
		}
	}
    private func startRecording() {
		
		// Ask for Authorisation from the User.
		self.locationManager.requestAlwaysAuthorization()

		if CLLocationManager.locationServicesEnabled() {
			locationManager.allowsBackgroundLocationUpdates = true
			locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
			locationManager.distanceFilter = 30 // 2 secs 30mph 1sec 60mph
			locationManager.startUpdatingLocation()
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
