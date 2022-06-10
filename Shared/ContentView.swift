//
//  ContentView.swift
//  Shared
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var state = AppState()
    
    var body: some View {
        DockView(state: state)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
