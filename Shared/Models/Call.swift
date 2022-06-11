//
//  Call.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 6/10/22.
//

import Foundation

struct Call: Identifiable {
    var id = UUID()
    var users: [UUID]
    var roomID: UUID?
}
