//
//  RemotionSwiftUIApp.swift
//  Shared
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

@main
struct RemotionSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            ContentView()
                .frame(minWidth: 80, maxWidth: 200, idealHeight: 800)
            #else
            ContentView()
            #endif
        }
    }
}
