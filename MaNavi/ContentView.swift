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
    @State var featuredItem: MKMapItem? = nil
    @StateObject var sheetModel = SheetModel()
    
    init() {
        CLLocationManager.locationServicesEnabled()
        manager.requestWhenInUseAuthorization()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(mapType: .standard, region: $region, selectedItem: $featuredItem, sheetModel: sheetModel)
                .ignoresSafeArea(edges: .vertical)
            
            if isBarShown {
                BottomBar(isBarShown: $isBarShown, sheetModel: sheetModel)
            } else {
                CollapsedBar(isBarShown: $isBarShown)
            }
            
            if sheetModel.isDetailsShown {
                DetailsSheet(sheetModel: sheetModel, featuredItem: $featuredItem, currentLocation: manager.location)
                    .offset(y: sheetModel.detailsOffset)
                    .onTapGesture { }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    sheetModel.detailsOffset = value.location.y
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.location.y < height / 2 {
                                        sheetModel.detailsOffset = height / 3
                                        return
                                    }
                                    sheetModel.detailsOffset = height - 220
                                }
                            }
                    )
                
            }
            
            if sheetModel.isSearchShown {
                SearchView(sheetModel: sheetModel, currentLocation: manager.location)
                    .offset(y: sheetModel.searchOffset)
                    .onTapGesture { }
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    sheetModel.searchOffset = value.location.y
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if value.location.y < height / 2 {
                                        sheetModel.searchOffset = 20
                                        return
                                    }
                                    sheetModel.searchOffset = height - 220
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
