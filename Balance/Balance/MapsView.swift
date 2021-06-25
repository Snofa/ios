//
//  MapsView.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import MapKit
import SwiftUI

struct MapsView: UIViewRepresentable {

    @Binding var centerCoordinate: CLLocationCoordinate2D
    var currentLocation: CLLocationCoordinate2D?

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapsView

        init(_ parent: MapsView) {
            self.parent = parent
        }

        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            if !mapView.showsUserLocation {
                parent.centerCoordinate = mapView.centerCoordinate
            }
        }
    }


    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let currentLocation = self.currentLocation {
            uiView.showsUserLocation = true
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 800, longitudinalMeters: 800)
            uiView.setRegion(region, animated: true)
        }
    }
}
