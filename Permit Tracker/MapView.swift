//
//  MapView.swift
//  Permit Tracker
//
//  Created by Everett Wilber on 8/9/21.
//

import SwiftUI
import MapKit


struct MapView: UIViewRepresentable {
	var driveDetails: DriveDetails
	var isDriving: Bool
	func makeUIView(context: Context) -> MKMapView {
		print("making map view - function: ", #function)
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		
		let polyline = MKPolyline(coordinates: driveDetails.Locations2d, count: driveDetails.Locations.count)
		mapView.addOverlay(polyline)
		if isDriving {
			mapView.showsUserLocation = true
			mapView.setUserTrackingMode(.follow, animated: true)
			mapView.region = .init(center: driveDetails.Locations2d.first ?? CLLocationCoordinate2D(), latitudinalMeters: 4, longitudinalMeters: 4)
		} else {
			mapView.region = .init(center: polyline.coordinate, latitudinalMeters: 1, longitudinalMeters: 1)
		}
		
		return mapView
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
		print("updating map ui - function: ", #function)
		
		let polyline = MKPolyline(coordinates: driveDetails.Locations2d, count: driveDetails.Locations.count)
		
		if let overlay = uiView.overlays.first {
			uiView.addOverlay(polyline)
			uiView.removeOverlay(overlay)
		} else {
			uiView.addOverlay(polyline)
		}
		
		if isDriving {
			
//			if let location = driveDetails.locations.last {
//				let camera = uiView.camera
//				camera.pitch = 40
//				camera.heading = location.course
//				camera.centerCoordinate = location.coordinate
//				uiView.setCamera(camera, animated: true)
//			}
			
		} else {
			print("user is not driving")
			uiView.region.center = polyline.coordinate
		}
//		let Start = MKPointAnnotation()
//		Start.coordinate = Locations[0]
//		Start.title = "Start"
//		
//		//MARK - End Annotation
//		let End = MKPointAnnotation()
//		End.coordinate = Locations[Locations.count - 2]
//		End.title = "End"
//		
//		uiView.addAnnotations([Start, End])
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
		print("update overlay")
		if let routePolyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: routePolyline)
			renderer.strokeColor = UIColor.systemRed
			renderer.lineWidth = 5
			return renderer
		}
		
		return MKOverlayRenderer()
	}
}
