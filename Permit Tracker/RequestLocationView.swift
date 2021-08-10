//
//  RequestLocationView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/10/21.
//

import SwiftUI
import CoreLocation

struct RequestLocationView: View {
	@EnvironmentObject var locationViewModel: LocationViewModel
	
	var body: some View {
		VStack {
			Image(systemName: "location.circle")
				.resizable()
				.frame(width: 100, height: 100, alignment: .center)
				.foregroundColor(.blue)
			Button(action: {
				locationViewModel.requestPermission()
			}, label: {
				Label("Allow tracking", systemImage: "location")
			})
			.padding(10)
			.foregroundColor(.white)
			.background(Color.blue)
			.clipShape(RoundedRectangle(cornerRadius: 8))
			Text("We need your permission to track you.")
				.foregroundColor(.gray)
				.font(.caption)
		}
	}
}

struct ErrorView: View {
	var errorText: String
	
	var body: some View {
		VStack {
			Image(systemName: "xmark.octagon")
					.resizable()
				.frame(width: 100, height: 100, alignment: .center)
			Text(errorText)
		}
		.padding()
		.foregroundColor(.white)
		.background(Color.red)
	}
}

struct TrackingView: View {
	@EnvironmentObject var locationViewModel: LocationViewModel
	
	
	var body: some View {
		VStack {
			VStack {
				Text(String(coordinate?.latitude ?? 0))
				Text(String(coordinate?.longitude ?? 0))
				Text(String(locationViewModel.lastSeenLocation?.altitude ?? 0))
				Text(String(locationViewModel.lastSeenLocation?.speed ?? 0))
				Text(locationViewModel.currentPlacemark?.country ?? "")
				Text(locationViewModel.currentPlacemark?.administrativeArea ?? "")
			}
			.padding()
		}
	}
	
	var coordinate: CLLocationCoordinate2D? {
		locationViewModel.lastSeenLocation?.coordinate
	}
}
