//
//  ContentView.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/09.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    let manager = CLLocationManager()
    @State private var region: MKCoordinateRegion? = nil
    @State private var isBarShown = true
    @State var isCardShown = false
    @State var isSearchViewShown = false
    @State var featuredItem: MKMapItem? = nil
    @State var infoOffset: CGFloat = 20
    @State var searchOffset: CGFloat = 20
    
    init() {
        CLLocationManager.locationServicesEnabled()
        manager.requestWhenInUseAuthorization()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(mapType: .standard, region: $region, isCardShown: $isCardShown, offset: $infoOffset, selectedItem: $featuredItem)
                .ignoresSafeArea(edges: .vertical)
            
            if isBarShown {
                BottomBar(isBarShown: $isBarShown, isSearchViewShown: $isSearchViewShown, searchOffset: $searchOffset)
            } else {
                CollapsedBar(isBarShown: $isBarShown)
            }
            
            if isCardShown {
                DetailsSheet(isCardShown: $isCardShown, offset: $infoOffset, featuredItem: $featuredItem, currentLocation: manager.location)
                    .onAppear() {
                        infoOffset = height - 220
                    }
                    .offset(y: infoOffset)
                    .onTapGesture { }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    infoOffset = value.location.y
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.location.y < height / 2 {
                                        infoOffset = height / 3
                                        return
                                    }
                                    infoOffset = height - 220
                                }
                            }
                    )
                
            }
            
            if isSearchViewShown {
                SearchView(isSearchViewShown: $isSearchViewShown, searchOffset: $searchOffset, currentLocation: manager.location)
                    .onAppear() {
                        searchOffset = height - 190
                    }
                    .offset(y: searchOffset)
                    .onTapGesture { }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    searchOffset = value.location.y
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.location.y < height / 2 {
                                        searchOffset = 20
                                        return
                                    }
                                    searchOffset = height - 220
                                }
                            }
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
