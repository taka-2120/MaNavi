//
//  SearchView.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/13.
//

import SwiftUI
import CoreLocation
import MapKit

struct SearchView: View {
    
    @State var searchText = ""
    @Binding var isSearchViewShown: Bool
    @Binding var searchOffset: CGFloat
    let currentLocation: CLLocation?
    @State var places = [MKMapItem]()
    @State var radius = 5000
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 50, height: 5)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            searchOffset = height
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isSearchViewShown = false
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(.label))
                            .font(.body.weight(.bold))
                            .padding(8)
                    })
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(100)
                }
            }
            .padding([.top, .horizontal])
            
            HStack {
                Text("検索半径:")
                Spacer()
                Button(action: {
                    //Show Menu (1, 2, 5, 10)
                }, label: {
                    Text(String(radius/1000) + "km")
                })
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            SearchField(searchText: $searchText, searchOffset: $searchOffset, onSubmit: searchResult)
                .padding(.bottom)
            
            ScrollView {
                if places.count == 0 {
                    Text("検索結果がありません")
                } else {
                    ForEach(places, id: \.self) { place in
                        ReaultRow(place: place, currentLocation: currentLocation!)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear() {
            searchResult(searchString: "School")
        }
    }
    
    func searchResult(searchString: String) {
        guard let loc = currentLocation else {
            print("I don't know where you are now")
            return
        }
        
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = searchString
        req.region = MKCoordinateRegion(center: loc.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        let search = MKLocalSearch(request: req)
        search.start { response, error in
            places = response?.mapItems ?? []
        }
        
    }
}

struct ReaultRow: View {
    let place: MKMapItem
    let currentLocation: CLLocation
    
    var body: some View {
        Button(action: {
        }, label: {
            HStack {
                let distance = place.placemark.location?.distance(from: currentLocation) ?? 0
                Text(place.name!)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(String(format: "%.2fkm", distance/1000))
            }
            .foregroundColor(Color(.label))
        })
        .padding([.horizontal, .top])
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(isSearchViewShown: .constant(true), searchOffset: .constant(0), currentLocation: CLLocation(latitude: 36.2048, longitude: 138.2529))
    }
}
