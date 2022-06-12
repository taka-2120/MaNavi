//
//  Functions.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/12.
//

import Foundation
import MapKit

func poiToString(poiCat: MKPointOfInterestCategory?) -> String {
    switch poiCat ?? .school {
    case .school: return "学校"
    case .publicTransport: return "公共交通機関"
    case .university: return "大学"
    default: return "その他"
    }
}
