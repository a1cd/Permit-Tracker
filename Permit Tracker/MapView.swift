//
//  MapView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
	func makeUIView(context: Context) -> MKMapView {
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		
		let dist = 0.02
		let span = MKCoordinateSpan(latitudeDelta: dist, longitudeDelta: dist)
		
		mapView.region = .init(center: Locations[0], span: span)
		
		let polyline = MKPolyline(coordinates: Locations, count: Locations.count)
		mapView.addOverlay(polyline)
		
		return mapView
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		let Start = MKPointAnnotation()
		Start.coordinate = Locations[0]
		Start.title = "Start"
		
		//MARK - End Annotation
		let End = MKPointAnnotation()
		End.coordinate = Locations[Locations.count - 2]
		End.title = "End"
		
		uiView.addAnnotations([Start, End])
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
}

class Coordinator: NSObject, MKMapViewDelegate {
	var parent: MapView
	
	init(_ parent: MapView) {
		self.parent = parent
	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let routePolyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: routePolyline)
			renderer.strokeColor = UIColor.systemBlue
			renderer.lineWidth = 10
			return renderer
		}
		
		return MKOverlayRenderer()
	}
}
