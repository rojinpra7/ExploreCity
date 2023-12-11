//
//  ExploreView.swift
//  ExploreCity
//
//  Created by Rojin Prajapati on 12/5/23.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let home = CLLocationCoordinate2D(latitude: 42.2785424, longitude: -85.6449113
    )
}

extension MKCoordinateRegion {
    static let chicago = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
}


struct ExploreView: View {
    @Binding var locationManager: CLLocationManager
    @Binding var cityName: String
    var cityRegion: MKCoordinateRegion
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var mapPostion: MapCameraPosition = .automatic
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    var body: some View {
        Map(position: $mapPostion, selection: $selectedResult){
            Marker("Home", coordinate: .home)
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
            }
            
            UserAnnotation()
            
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 7)
                    
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack{
                Spacer()
                VStack(spacing: 0) {
                    if let selectedResult {
                        ItemInfoView(selectedResult: selectedResult, route: route)
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding()
                    }
                    RestaurantButtonView(visibleRegion: visibleRegion, mapPostion: $mapPostion, searchResults: $searchResults)
                }
                Spacer()
            }.background(.thinMaterial)
            
        }
        .mapStyle(.standard(elevation: .realistic))
//        .onChange(of: searchResults) {
//            mapPostion = .automatic
//        }
        .onChange(of: selectedResult) {
            getDirection()
        }
        .onMapCameraChange{ context in
            visibleRegion = context.region
        }
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            
        }
        .onAppear{
            locationManager.requestWhenInUseAuthorization()
            switch locationManager.authorizationStatus {
            case .authorizedAlways:
                print("Authorized Always")
            case .authorizedWhenInUse:
                print("Authorized When In Use")
            case .denied:
                print("")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            default:
                print("Location service is not available or disabed by the user.")
            }
            
            print("-----------------------")
            print("on appear: \(cityName)")
            print("on appear: \(cityRegion)")
            print("-----------------------")
            mapPostion = .region(cityRegion)
        }
//        .alert(isPresented:) {
//            Alert(title: Text("Turn on the location services to enjoy the full capability of the ExploreCity app."))
//        }
        
    }
    
    func getDirection() {
        route = nil
        guard let selectedResult else { return }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: .home))
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
    
}

//#Preview {
//    HomeScreen(locationManager: .constant(CLLocationManager()), cityName: .constant(""), cityRegion: .constant())
//}
