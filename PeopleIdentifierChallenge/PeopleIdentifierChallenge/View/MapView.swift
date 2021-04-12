//
//  MapView.swift
//  PeopleIdentifierChallenge
//
//  Created by Ryan Park on 3/4/21.
//

import SwiftUI
import MapKit

struct MapView {
    var annotation: MKPointAnnotation?
}

extension MapView: UIViewRepresentable {

    func makeUIView(context: Self.Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        if let annotation = annotation {
            mapView.setCenter(annotation.coordinate, animated: false)
        }
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Self.Context) {
        if let annotation = annotation {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotation(annotation)
        }
    }

    func makeCoordinator() -> Self.Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "Location"

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
    }
}
