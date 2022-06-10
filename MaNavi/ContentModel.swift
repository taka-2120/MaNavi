//
//  ContentModel.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/10.
//

import Foundation
import MapKit

class ContentViewModel: ObservableObject{
    @Published var isCardShown = false
    @Published var featuredItem: MKMapItem? = nil
}
