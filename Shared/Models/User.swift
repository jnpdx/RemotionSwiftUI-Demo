//
//  User.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation

struct User: Identifiable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var avatar: String?
    var status: String?
    var pronouns: String?
    var availability: Availability
    var isCalling: Bool = false
    var isPinned: Bool = true
    
    enum Availability {
        case active, focused, away
    }
}
