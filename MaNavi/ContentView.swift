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
    @State var featuredItem: MKMapItem? = nil
    @State var offset: CGFloat = 0
    let height = UIScreen.main.bounds.height
    
    init() {
        CLLocationManager.locationServicesEnabled()
        manager.requestWhenInUseAuthorization()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(mapType: .standard, region: $region, isCardShown: $isCardShown, offset: $offset, selectedItem: $featuredItem)
                .ignoresSafeArea(edges: .vertical)
            
            if isBarShown {
                BottomBar(isBarShown: $isBarShown)
            } else {
                CollapsedBar(isBarShown: $isBarShown)
            }
            
            if isCardShown {
                InteractiveSheet(isCardShown: $isCardShown, offset: $offset, featuredItem: $featuredItem, currentLocation: manager.location)
                    .onAppear() {
                        offset = height - 220
                    }
                    .offset(y: offset)
                    .onTapGesture {
                        
                    }
                    .gesture(DragGesture()
                        .onChanged { value in
                            withAnimation {
                                print(value.translation.height)
                                offset = value.location.y
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.location.y < height / 2 {
                                    offset = height / 3
                                    return
                                }
                                offset = height - 220
                            }

                            print(offset)
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
