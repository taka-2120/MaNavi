//
//  MaNaviApp.swift
//  MaNavi
//
//  Created by Yu Takahashi on 2022/06/09.
//

import SwiftUI

@main
struct MaNaviApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16, *) {
                ContentView()
            } else {
                ContentView_OLD()
            }
        }
    }
}
