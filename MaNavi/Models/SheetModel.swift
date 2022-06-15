//
//  SheetModel.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/15.
//

import SwiftUI

class SheetModel: ObservableObject {
    @Published var isDetailsShown = false
    @Published var detailsOffset: CGFloat = 20
    @Published var isSearchShown = false
    @Published var searchOffset: CGFloat = 20
    
    func showSearch() {
        isSearchShown = true
        searchOffset = height
        withAnimation(.easeInOut) {
            searchOffset = height - 220
        }
    }
    
    func closeSearch() {
        withAnimation(.easeInOut(duration: 0.3)) {
            searchOffset = height
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isSearchShown = false
        }
    }
    
    func showDetails() {
        isDetailsShown = true
        detailsOffset = height
        withAnimation(.easeInOut) {
            detailsOffset = height - 220
        }
    }
    
    func closeDetails() {
        withAnimation(.easeInOut(duration: 0.3)) {
            detailsOffset = height
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isDetailsShown = false
        }
    }
}
