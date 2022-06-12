//
//  Data.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/12.
//

import Foundation

enum Transportation: String, CaseIterable, Identifiable {
    case walk, publicTrans, car
    var id: Self { self }
}

extension Transportation {
    var toSysIcon: String {
        switch self {
        case .walk: return "figure.walk"
        case .publicTrans: return "bus"
        case .car: return "car"
        }
    }
}
