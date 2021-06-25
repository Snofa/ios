//
//  MapDetail.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
let id = UUID()
let name: String
let latitude: Double
let longitude: Double
var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

struct MapDetail: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Invoice>
    

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 49.2, longitude: 16.6),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
        


    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: false,  annotationItems: getPin()){ place in
                MapPin(coordinate: place.coordinate)
    }
    
    
    }
    
    func getPin() -> Array<Place> {
        var result:[Place] = []
        
        for task in tasks {
            result += [Place(name: task.descriptionText ?? "No description" , latitude: task.latitude, longitude: task.longitude)]
        }
        return result
    }
}

struct MapDetail_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
