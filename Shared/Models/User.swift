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

extension User {
    static var randomAvatarImageName: String {
        "Avatar-\((1...9).randomElement()!)"
    }
    
    static func testUserSet(number: Int) -> [User] {
        return [
            .init(name: "Alexander \(number)", avatar: User.randomAvatarImageName, availability: .active, isCalling: false),
            .init(name: "John \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Zak \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Fernando \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Harriet \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Kay-Anne \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Charley \(number)",  avatar: User.randomAvatarImageName,availability: .active),
            .init(name: "Angela \(number)",  avatar: User.randomAvatarImageName,availability: .away),
            .init(name: "TJ \(number)",  avatar: User.randomAvatarImageName,availability: .away),
        ]
    }
}
