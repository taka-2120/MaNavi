//
//  CardView.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/11.
//

import SwiftUI
import MapKit

struct CardView: View {
    @Binding var isCardShown: Bool
    @Binding var offset: CGFloat
    @Binding var featuredItem: MKMapItem?
    @State private var selectedTrans: Transportation = .walk
    let currentLocation: CLLocation?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("出発地: ")
                    Button(action: {
                        //Search Location
                    }, label: {
                        Label("現在地", systemImage: "figure.walk.departure")
                            .padding(8)
                    })
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.3)) {
                            let height = UIScreen.main.bounds.height
                            offset = height
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isCardShown = false
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
                .padding(.top, 8)
                
                Divider()
                
                
                HStack {
                    Text((featuredItem?.name) ?? "未選択")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Text(poiToString(poiCat: featuredItem?.pointOfInterestCategory))
                }
                
                if currentLocation != nil {
                    let distance = featuredItem?.placemark.location?.distance(from: currentLocation!) ?? 0 //meter
                    Text("直線距離" + String(format: "%.2fkm", distance/1000))
                } else {
                    Text("距離不明")
                }
                
                if featuredItem?.url?.absoluteString ?? "" != "" {
                    let url = (featuredItem?.url!.absoluteString)!
                    
                    Link(url, destination: URL(string: url)!)
                        .multilineTextAlignment(.leading)
                }
                
                Divider()
                
                Picker("", selection: $selectedTrans) {
                    ForEach(Transportation.allCases) { trans in
                        Image(systemName: trans.toSysIcon)
                    }
                }
                .pickerStyle(.segmented)
                
                Text("ETA: --分")
                    .padding(.vertical)
                
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Text("経路詳細")
                            .foregroundColor(.white)
                            .frame(width: 180, height: 40)
                    })
                    .background(.blue)
                    .cornerRadius(15)
                    Spacer()
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding()
        .edgesIgnoringSafeArea(.bottom)
    }
}


//BLUR
