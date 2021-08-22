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
//		print("making map view - function: ", #function)
		let mapView = MKMapView()
		mapView.delegate = context.coordinator
		
		let polyline = MKPolyline(coordinates: driveDetails.Locations2d, count: driveDetails.Locations.count)
		mapView.addOverlay(polyline)
		if isDriving {
			mapView.pointOfInterestFilter = .init(including: [.evCharger, .gasStation, .hospital, .marina, .park, .parking, .postOffice, .school, .restroom])
			mapView.showsTraffic = true
			mapView.showsUserLocation = true
			mapView.setUserTrackingMode(.followWithHeading, animated: true)
			mapView.region = .init(center: driveDetails.Locations2d.first ?? CLLocationCoordinate2D(), latitudinalMeters: 4, longitudinalMeters: 4)
			let compass = MKCompassButton(mapView: mapView)
			let track = MKUserTrackingButton(mapView: mapView)
			mapView.addSubview(compass)
			mapView.addSubview(track)
		} else {
			var regionRect = polyline.boundingMapRect


			let wPadding = regionRect.size.width * 0.25
			let hPadding = regionRect.size.height * 0.25

			//Add padding to the region
			regionRect.size.width += wPadding
			regionRect.size.height += hPadding

			//Center the region on the line
			regionRect.origin.x -= wPadding / 2
			regionRect.origin.y -= hPadding / 2

			let regionThatFits = mapView.regionThatFits(MKCoordinateRegion(regionRect))
			mapView.setRegion(regionThatFits, animated: true)
		}
		
//		var polylines: [MKPolyline] = []
//		for (start, end) in driveDetails.innacurateLocations {
//			let request = MKDirections.Request()
//			request.source = MKMapItem(placemark: MKPlacemark(coordinate: start.coordinate))
//			request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end.coordinate))
//			let directions = MKDirections(request: request)
//			directions.calculate { (Response, Error) in
//				if Response != nil {
//					if let estimatedRoute = Response?.routes.first?.polyline {
//						polylines.append(estimatedRoute)
//					}
//				}
//			}
//		}
//		mapView.addOverlays(polylines)
		
		return mapView
	}

	func updateUIView(_ uiView: MKMapView, context: Context) {
//		print("updating map ui - function: ", #function)
		
		let polyline = MKPolyline(coordinates: driveDetails.Locations2d, count: driveDetails.Locations.count)
		
		if let overlay = uiView.overlays.first {
			uiView.addOverlay(polyline)
			uiView.removeOverlay(overlay)
		} else {
			uiView.addOverlay(polyline)
		}
		
		if isDriving {
			
//			if let location = driveDetails.Locations.last {
//				let camera = uiView.camera
//				camera.pitch = 40
//				camera.heading = location.course
//				camera.centerCoordinate = location.coordinate
//				uiView.setCamera(camera, animated: true)
//			}
			
		} else {
			
//			print("user is not driving")
			let Start = MKPointAnnotation()
			Start.coordinate = polyline.points()[0].coordinate
			Start.title = "Start"
			
			//MARK - End Annotation
			let End = MKPointAnnotation()
			End.coordinate = polyline.points()[polyline.pointCount-1].coordinate
			End.title = "End"
			
			uiView.addAnnotations([Start, End])
		}
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
//		print("update overlay")
		if let routePolyline = overlay as? MKPolyline {
			let renderer = MKPolylineRenderer(polyline: routePolyline)
			renderer.strokeColor = UIColor.systemRed
			renderer.lineWidth = 5
			renderer.lineDashPattern = [20, 10, 0, 10]
			return renderer
		}
		
		return MKOverlayRenderer()
	}
	
	
}
