//
//  State.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation

class AppState: ObservableObject {
    @Published var team: Team
    
    init() {
        let users: [User] = [
            .init(name: "Alexander", availability: .active),
            .init(name: "John", availability: .active),
            .init(name: "Zak", availability: .active),
            .init(name: "Fernando", availability: .active),
            .init(name: "Harriet", availability: .active),
            .init(name: "Charley", availability: .active),
            .init(name: "Angela", availability: .away),
            .init(name: "TJ", availability: .away),
        ]
        let rooms: [Room] = [
            .init(name: "Coworking Lounge", color: .blue, users: [users.first!.id, users.last!.id]),
            .init(name: "Music", color: .green, users: []),
            .init(name: "SwiftUI Experience", color: .red, users: []),
            .init(id: UUID(), name: "Share Pod", avatar: nil, color: .yellow, users: [], isPinned: false),
            .init(id: UUID(), name: "Design Studio", avatar: nil, color: .white, users: [], isPinned: false)
        ]
        team = Team(users: users, rooms: rooms)
    }
    
    var pinnedRooms: [Room] {
        team.rooms.filter { $0.isPinned }
    }
    
    var unPinnedRooms: [Room] {
        team.rooms.filter { !$0.isPinned }
    }
    
    var pinnedUsers: [User] {
        team.users
            .filter { $0.isPinned }
            .sorted { $0.availability == .active && $1.availability != .active ? true : false }
    }
}
