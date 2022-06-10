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
    
    @State private var region: MKCoordinateRegion? = nil
    @State private var isBarShown = true
    @State private var cardDetent = PresentationDetent.medium
    @State var isCardShown = false
    @State var featuredItem: MKMapItem? = nil
    
    let tokyo = CLLocationCoordinate2D(latitude: 36.2048, longitude: 138.2529)
    let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    
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
        .onAppear() {
            let manager = CLLocationManager()
            CLLocationManager.locationServicesEnabled()
            manager.requestWhenInUseAuthorization()
            
            self.region?.center = manager.location?.coordinate ?? tokyo
            self.region?.span = span
        }
        .sheet(isPresented: $isCardShown) {
            CardView(featuredItem: $featuredItem)
                .presentationDetents (
                    [.medium, .large],
                    selection: $cardDetent
                 )
        }
    }
}

struct CardView: View {
    @Binding var featuredItem: MKMapItem?
    
    var body: some View {
        Text((featuredItem?.name) ?? "Not Selected")
    }
}

struct CollapsedBar: View {
    @Binding var isBarShown: Bool
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isBarShown.toggle()
                    }
                }, label: {
                    Image(systemName: isBarShown ? "eye.slash" : "eye")
                        .foregroundColor(Color(.label))
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                })
                .frame(width: 40, height: 40)
                .background(Color(.secondarySystemBackground).opacity(0.7))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.bottom, 45)
            }
        }
    }
}

struct BottomBar: View {
    
    @Binding var isBarShown: Bool
    
    var body: some View {
        HStack {
            Text("MaNavi")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {
                
            }, label: {
                Image(systemName: "list.bullet.rectangle.portrait")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 18, weight: .bold))
            })
            .frame(width: 40, height: 40)
            .background(Color(.secondarySystemBackground).opacity(0.7))
            .cornerRadius(20)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isBarShown.toggle()
                }
            }, label: {
                Image(systemName: isBarShown ? "eye.slash" : "eye")
                    .foregroundColor(Color(.label))
                    .font(.system(size: 18, weight: .bold))
                    .padding()
            })
            .frame(width: 40, height: 40)
            .background(Color(.secondarySystemBackground).opacity(0.7))
            .cornerRadius(20)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .padding(.horizontal, 15)
        .padding(.bottom, 30)
        .shadow(radius: 10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
