//
//  Functions.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/12.
//

import SwiftUI
import MapKit

extension Optional where Wrapped == MKPointOfInterestCategory {
    func toString() -> String {
        switch self ?? .school {
        case .school: return "学校"
        case .publicTransport: return "公共交通機関"
        case .university: return "大学"
        default: return "その他"
        }
    }
}
