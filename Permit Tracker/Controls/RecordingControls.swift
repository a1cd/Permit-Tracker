//
//  RecordingControls.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 2/15/22.
//

import SwiftUI
import CoreLocation

struct RecordingControls: View {
	@Binding var Recording: Bool
	
	var StartRecording: () -> Void
	var StopRecording: () -> Void
	@Binding var locationAccess: CLAuthorizationStatus
	@Binding var cannotAccessLocation: Bool
	
	@State var notices: [NoticeData] = [
		NoticeData(icon: "location.fill", title: "Mapping", text: "After each drive, [App Name] creates a map of where you have been and tells you how far you traveled."),
		NoticeData(icon: "mappin.and.ellipse", title: "Location", text: "To make a map, [App Name] must collect your location while your phone is off."),
		NoticeData(icon: "stopwatch", title: "Time", text: "[App Name] also times how long you spend driving so you don't have to!")
	]
	
	var body: some View {
		VStack{
//			ScrollView {
			Spacer()
			ForEach($notices) {a in
				NoticeView(notice: a)
					.padding()
			}
			Spacer()
//			}
			Button(action: {
				if (Recording) {
					StopRecording()
				} else {
					StartRecording()
				}
			}, label: {
				Label("Start Recording", systemImage: "stopwatch")
					.padding(.vertical, 7.5)
					.padding(.horizontal)
					.labelStyle(TitleOnlyLabelStyle())
					
			})
				.buttonStyle(BorderedProminentButtonStyle())
				.padding(2.5)
				.shadow(radius: 4)
				
				
//			RecordButton(recording: $Recording)
//				.onTapGesture {
//					if (Recording) {
//						StopRecording()
//					} else {
//						StartRecording()
//					}
//				}
//				.alert(isPresented: $cannotAccessLocation, content: {
//					Alert(title: Text("Location Tracking"), message: Text("You need location tracking to start a drive! To use the app you need to allow location usage!"), dismissButton: Alert.Button.default(Text("Dismiss"), action: {
//						guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//							return
//						}
//
//						if UIApplication.shared.canOpenURL(settingsUrl) {
//							UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//								print("Settings opened: \(success)") // Prints true
//							})
//						}
//					}))
//				})
		}
		
	}
}

struct RecordingControls_Previews: PreviewProvider {
    static var previews: some View {
		RecordingControls(Recording: .constant(true), StartRecording: {}, StopRecording: {}, locationAccess: .constant(CLAuthorizationStatus.authorizedAlways), cannotAccessLocation: .constant(false))
    }
}

class NoticeData: ObservableObject, Equatable, Identifiable {
	init(icon: String, title: String, text: String) {
		self.text = text
		self.icon = icon
		self.title = title
	}
	@Published var icon: String = ""
	@Published var title: String = ""
	@Published var text: String = ""
	
	static func == (lhs: NoticeData, rhs: NoticeData) -> Bool {
		return lhs.icon == rhs.icon &&
		lhs.title == rhs.title &&
		lhs.text == rhs.text
	}
}

struct NoticeView: View {
	@Binding var notice: NoticeData
	var body: some View {
		HStack {
			Image(systemName: notice.icon)
				.resizable()
				.scaledToFit()
				.symbolRenderingMode(SymbolRenderingMode.multicolor)
				.frame(width: 60.0, height: 60.0)
				.padding(5.0)
			VStack {
				HStack {
					Text(notice.title)
						.font(.title)
						.fontWeight(.medium)
						.multilineTextAlignment(.leading)
					Spacer()
				}
				HStack {
					Text(notice.text)
						.multilineTextAlignment(.leading)
					Spacer()
				}
			}
		}
		.padding()
	}
}
