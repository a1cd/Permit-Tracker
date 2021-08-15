//
//  ToolBar.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/11/21.
//

import SwiftUI
import CoreLocation

struct ToolBar: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@Binding var Recording: Bool
	@State var Saving: Bool = false
	
	var StartRecording: () -> Void
	var StopRecording: () -> Void
	@State var locationAccess: CLAuthorizationStatus
	@State var cannotAccessLocation: Bool
	
	
	func RecordImage() -> some View {
		if (self.Recording) {
			return Image(systemName: "stop.circle")
				.font(.system(size: 25))
		} else {
			return Image(systemName: "record.circle")
				.font(.system(size: 25))
		}
	}
	
    var body: some View {
		HStack{
			RecordImage()
				.padding(.horizontal)
				.imageScale(.large)
				.foregroundColor(.red)
				.onTapGesture {
					if (Recording) {
						StopRecording()
					} else {
						StartRecording()
					}
				}
				.alert(isPresented: $cannotAccessLocation, content: {
					Alert(title: Text("Location Tracking"), message: Text("You need location tracking to start a drive! To use the app you need to allow location usage!"), dismissButton: Alert.Button.default(Text("Dismiss"), action: {
						guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
							return
						}

						if UIApplication.shared.canOpenURL(settingsUrl) {
							UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
								print("Settings opened: \(success)") // Prints true
							})
						}
					}))
				})
		}
    }
}

func Nothing(_ Nothing: Any?) {
	
}
func Nothing() {
	
}
struct ToolBar_Previews: PreviewProvider {
    static var previews: some View {
		ToolBar(
			Recording: .constant(false),
			StartRecording: Nothing,
			StopRecording: Nothing,
			locationAccess: CLAuthorizationStatus.authorizedAlways,
			cannotAccessLocation: !true
		)
    }
}
