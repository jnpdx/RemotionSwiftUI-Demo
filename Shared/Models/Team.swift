//
//  Team.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation

struct Team: Identifiable {
    var id = UUID()
    var users: [User]
    var rooms: [Room]
    var calls: [Call]
}
