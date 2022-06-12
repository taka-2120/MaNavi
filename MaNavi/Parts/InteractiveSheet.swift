//
//  InteractiveSheet.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/12.
//

import SwiftUI
import MapKit

struct InteractiveSheet: View {
    
    @Binding var isCardShown: Bool
    @Binding var offset: CGFloat
    @Binding var featuredItem: MKMapItem?
    let currentLocation: CLLocation?
    let height = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Capsule()
                .fill(.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
            
            CardView(isCardShown: $isCardShown, offset: $offset, featuredItem: $featuredItem, currentLocation: currentLocation)
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
