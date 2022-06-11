//
//  ContentView.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/09.
//

import SwiftUI
import MapKit
import CoreLocation

@available(iOS 16, *)
struct ContentView: View {
    let manager = CLLocationManager()
    @State private var region: MKCoordinateRegion? = nil
    @State private var isBarShown = true
    @State var isCardShown = false
    @State var featuredItem: MKMapItem? = nil
    @State var selectedDetent: PresentationDetent = .height(150)
    
    let tokyo = CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    init(region: MKCoordinateRegion? = nil, isBarShown: Bool = true, isCardShown: Bool = false, featuredItem: MKMapItem? = nil) {
        CLLocationManager.locationServicesEnabled()
        manager.requestWhenInUseAuthorization()
        self.region = region
        self.region?.center = manager.location?.coordinate ?? tokyo
        self.region?.span = span
        self.isBarShown = isBarShown
        self.isCardShown = isCardShown
        self.featuredItem = featuredItem
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView(mapType: .standard, region: $region, isCardShown: $isCardShown, selectedItem: $featuredItem)
                .ignoresSafeArea(edges: .vertical)
            
            if isBarShown {
                BottomBar(isBarShown: $isBarShown)
            } else {
                CollapsedBar(isBarShown: $isBarShown)
            }
        }
        .sheet(isPresented: $isCardShown) {
            CardView(featuredItem: $featuredItem, currentLocation: manager.location)
                .presentationDetents([.medium, .height(150), .height(45)], selection: $selectedDetent)
                .interactiveDismissDisabled(true)
                .disabled(false)
                
        }
    }
}

struct ContentView_OLD: View {
    let manager = CLLocationManager()
    @State private var region: MKCoordinateRegion? = nil
    @State private var isBarShown = true
    @State var isCardShown = false
    @State var featuredItem: MKMapItem? = nil
    
    let tokyo = CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    
    init(region: MKCoordinateRegion? = nil, isBarShown: Bool = true, isCardShown: Bool = false, featuredItem: MKMapItem? = nil) {
        CLLocationManager.locationServicesEnabled()
        manager.requestWhenInUseAuthorization()
        self.region = region
        self.region?.center = manager.location?.coordinate ?? tokyo
        self.region?.span = span
        self.isBarShown = isBarShown
        self.isCardShown = isCardShown
        self.featuredItem = featuredItem
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            MapView(mapType: .standard, region: $region, isCardShown: $isCardShown, selectedItem: $featuredItem)
                .ignoresSafeArea(edges: .vertical)
            
            if isBarShown {
                BottomBar(isBarShown: $isBarShown)
            } else {
                CollapsedBar(isBarShown: $isBarShown)
            }
        }
        .sheet(isPresented: $isCardShown) {
            CardView(featuredItem: $featuredItem, currentLocation: manager.location)
                .interactiveDismissDisabled(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16, *) {
            ContentView()
        } else {
            ContentView_OLD()
        }
    }
}
