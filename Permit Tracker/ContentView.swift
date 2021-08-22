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
import Dispatch

struct ContentView: View {
	@StateObject var locationViewModel = LocationViewModel()
    @Environment(\.managedObjectContext) private var viewContext
	@Environment(\.colorScheme) var colorScheme
	
    @FetchRequest(
		sortDescriptors: [NSSortDescriptor(keyPath: \Item.date, ascending: false)],
        animation: .default
	)
    private var Drives: FetchedResults<Item>

	@State var mostRecentDrive: Item?
	
	@State var Recording = false
	@State var WriteNotes = false
	@State var WeatherInt = 0
	@State var NotesString = ""
	@State var Supervisor = ""
	
	var AllDrives: [DriveDetails] {
		var list: [DriveDetails] = []
		for drive in Drives {
			 list.append(DriveDetails(item: drive))
		}
		return list
	}
	
	let locationManager = CLLocationManager()
	
	func CalculateStats(AllDrives: [DriveDetails]) -> Measurement<UnitLength> {
		var totalDistance: Double = 0
		for drive in AllDrives {
//			DispatchQueue.global(qos: .userInitiated).async {
				if var lastLocation = drive.Locations.first {
					for location in drive.Locations {
						totalDistance += location.distance(from: lastLocation)
						lastLocation = location
					}
				}
//			}
		}
		return Measurement(value: totalDistance, unit: UnitLength.meters)
	}
	func CalculateNightDriving(AllDrives: [DriveDetails]) -> TimeInterval {
		var time: TimeInterval = 0
		for drive in AllDrives {
			time += drive.TotalNightTime
		}
		return time
	}
	func CalculateTotalTime(AllDrives: [DriveDetails]) -> TimeInterval {
		var totalTime: TimeInterval = TimeInterval()
		for drive in AllDrives {
			totalTime += drive.TimeInterval
		}
		return totalTime
	}
	
//	func AsyncCacheDrivingValues() {
//		for drive in
//	}
	
	func DataChange() {
		
	}
	var body: some View {
		Group {
			VStack {
				VStack {
					if (Recording) {
						TrackingView(locationViewModel: locationViewModel)
					} else {
						NavigationView {
							ScrollView {
								UserStats(
									DistanceTraveled: CalculateStats(AllDrives: AllDrives),
									TimeTraveled: CalculateTotalTime(AllDrives: AllDrives),
									TotalNightTime: CalculateNightDriving(AllDrives: AllDrives)
								)
								.background(Color((colorScheme == ColorScheme.dark) ? UIColor.secondarySystemBackground : UIColor.systemBackground))
									.scaledToFit()
										
									.clipped()
									.cornerRadius(30)
									.shadow(radius: 1.5, x: 0, y: 2)
									.padding(.bottom, 3.5)
								Divider()
								// Drive list
								NavigationLink(destination: DriveList(locationViewModel: locationViewModel, Drives: Drives, deleteItems: deleteItems)) {
									Image(systemName: "map")
										.padding(.leading)
										.imageScale(.large)
									Text("Drive History")
										.multilineTextAlignment(.leading)
										.padding(.trailing)
									Spacer()
								}
									.foregroundColor(.primary)
								Divider()
								// Stats
								NavigationLink(destination: Stats(DistanceTraveled: CalculateStats(AllDrives: AllDrives), TimeTraveled: CalculateTotalTime(AllDrives: AllDrives), TotalNightTime: CalculateNightDriving(AllDrives: AllDrives), AllDrives: AllDrives)) {
									Image(systemName: "chart.bar")
										.padding(.leading)
										.imageScale(.large)
									Text("Stats")
										.multilineTextAlignment(.leading)
										.padding(.trailing)
									Spacer()
								}
									.foregroundColor(.primary)
								Spacer()
							}
						}
					}
				}
				HStack {
					ToolBar(
						Recording: $Recording,
						StartRecording: startRecording,
						StopRecording: stopRecording,
						locationAccess: locationViewModel.authorizationStatus,
						cannotAccessLocation: !isAuthorized(true)
					)
					.sheet(isPresented: $WriteNotes) {
						EndOfDrive(working: $WriteNotes, weather: $WeatherInt, notes: $NotesString, Supervisor: $Supervisor)
							.onDisappear(perform: {
								print(mostRecentDrive != nil)
								if mostRecentDrive != nil {
									print("Saving to most recent drive")
									print("Weather", WeatherInt)
									print("Notes", NotesString)
									mostRecentDrive!.weather = Int16(WeatherInt)
									mostRecentDrive!.notes = NotesString
									
									// save the new data
									do {
										print("saving context")
										try viewContext.save()
										print("Context Saved")
									} catch {
										print("context error")
										// Replace this implementation with code to handle the error appropriately.
										// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
							//				let nsError = error as NSError
										print("error", error)
							//				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
									}
									
								}
							})
					}
				}
				.background(Color(UIColor.systemBackground))
			}
		}
		.onAppear(perform: {
			locationViewModel.requestPermission()
		})
	}
	
    func startRecording() {
		mostRecentDrive = nil
		if isAuthorized() {
			locationViewModel.AuthChange = stopRecording
			Recording = true
			locationViewModel.locationManager.activityType = .automotiveNavigation
			locationViewModel.locationManager.startUpdatingLocation()
			locationViewModel.locationManager.startUpdatingHeading()
//			locationManager.pausesLocationUpdatesAutomatically = false
		} else {
			locationViewModel.locationManager.requestLocation()
		}
    }
	
	func Save() {
		locationViewModel.locationManager.stopUpdatingHeading()
		locationViewModel.locationManager.stopUpdatingLocation()
		let allLocations = locationViewModel.allLocations
		let newDrive = DriveDetails(allLocations)
		
		let driveSave = Item(context: viewContext)
		
		let saveLocations = newDrive.convertToCoreData(context: viewContext)
		
		driveSave.date = newDrive.StartDate
		driveSave.id = UUID()
		driveSave.locations = .init(array: saveLocations)
		
		mostRecentDrive = driveSave
		
		do {
			try viewContext.save()
			locationViewModel.allLocations = []
		} catch {
			// Replace this implementation with code to handle the error appropriately.
			// fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//				let nsError = error as NSError
			print("error", error)
//				fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
		}
		
		
		DataChange()
	}
	func isAuthorized(_ andDetermined: Bool = false) -> Bool {
		print(locationViewModel.authorizationStatus.rawValue, "at: ", #file, #line)
		switch locationViewModel.authorizationStatus {
		case .authorizedAlways:
			return true
		case .authorizedWhenInUse:
			return true
		case .notDetermined:
			if andDetermined {
				return true
			} else {
				return false
			}
		default:
			return false
		}
	}
	func stopRecording() {
		if isAuthorized() {
			locationViewModel.AuthChange = Nothing
			Save()
			Recording = false
			WriteNotes = true
		} else {
			print("Not authorized")
		}
	}
//
    func deleteItems(offsets: IndexSet) {
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
			DataChange()
			
        }
    }
	
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
	formatter.doesRelativeDateFormatting = true
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
