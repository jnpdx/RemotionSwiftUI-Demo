//
//  SimulatorDriver.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 6/13/22.
//

import Foundation
import Combine
import SwiftUI

class StateSimulator {
    var cancelable: AnyCancellable?
    
    private enum Actions: CaseIterable {
        case toggleCalling
        case joinRoom
        case joinCall
        case leaveCall
        case toggleAvailability
        case toggleTalking
        case sendEmoji
    }
    
    static func generateSampleTeam() -> Team {
        let users: [User] = (1...2).map { User.testUserSet(number: $0) }.flatMap { $0 }
        let rooms: [Room] = [
            .init(name: "Coworking Lounge", color: .blue),
            .init(name: "Music", color: .green),
            .init(name: "SwiftUI Experience", color: .red),
            .init(id: UUID(), name: "Share Pod", avatar: nil, color: .yellow, isPinned: false),
            .init(id: UUID(), name: "Design Studio", avatar: nil, color: .white, isPinned: false)
        ]
        let calls: [Call] = [
            .init(users: [users.first!.id, users.last!.id], roomID: rooms.first!.id)
        ]
        return Team(users: users, rooms: rooms, calls: calls)
    }
    
    func startSimulation(appState: AppState) {
        cancelable = Timer.publish(every: 0.2, on: .main, in: .common)
            .autoconnect()
            .map { (_) -> Team in
                guard var user = appState.team.users.randomElement() else {
                    return appState.team
                }
                var team = appState.team
                
                let action = Actions.allCases.randomElement()!
                
                switch action {
                case .toggleTalking:
                    if team.calls.contains(where: { call in call.users.contains(user.id) }) {
                        user.isTalking.toggle()
                    }
                case .toggleCalling:
                    user.isCalling.toggle()
                    if user.isCalling {
                        user.availability = .active
                    }
                case .joinRoom:
                    guard let randomRoom = team.rooms.randomElement() else {
                        break
                    }
                    
                    self.removeUserFromAllCalls(team: &team, userID: user.id)
                    
                    // is there already a call
                    if var call = team.calls.first(where: { $0.roomID == randomRoom.id }) {
                        call.users.append(user.id)
                        team.calls = team.calls.map { $0.id == call.id ? call : $0 }
                    } else {
                        let call = Call(id: UUID(), users: [user.id], roomID: randomRoom.id)
                        team.calls.append(call)
                    }
                    user.availability = .active
                case .leaveCall:
                    self.removeUserFromAllCalls(team: &team, userID: user.id)
                    user.isTalking = false
                case .joinCall:
                    guard let randomUser = team.users.randomElement() else {
                        break
                    }
                    
                    self.removeUserFromAllCalls(team: &team, userID: user.id)
                    self.removeUserFromAllCalls(team: &team, userID:randomUser.id)
                    
                    team.calls.append(Call(id: UUID(), users: [user.id, randomUser.id], roomID: nil))
                    user.availability = .active
                    
                case .toggleAvailability:
                    user.availability = User.Availability.allCases.randomElement()!
                    
                    if user.availability == .away {
                        // remove the users from any other calls
                        self.removeUserFromAllCalls(team: &team, userID: user.id)
                    }
                    
                    if user.availability != .active {
                        user.isCalling = false
                        user.isTalking = false
                    }
                case .sendEmoji:
                    let randomEmoji = ["🐱","😀","💡","❤️","🔥","🎉"].randomElement()!
                    user.sentEmoji = SentEmoji(emoji: randomEmoji)
                }
                
                team.users = team.users.map { $0.id == user.id ? user : $0 }
                return team
            }
            .sink(receiveValue: { newState in
                withAnimation(.linear(duration: 0.3)) {
                    appState.team = newState
                }
            })
    }
    
    func removeUserFromAllCalls(team: inout Team, userID: UUID) {
        team.calls = team.calls.map { call in
            if call.users.contains(userID) {
                var copy = call
                copy.users.removeAll(where: { $0 == userID })
                return copy
            }
            return call
        }
    }
}

extension User {
    static var randomAvatarImageName: String {
        "Avatar-\((1...9).randomElement()!)"
    }
    
    static func testUserSet(number: Int) -> [User] {
        return [
            .init(name: "Alexander \(number)", avatar: "Avatar-1", availability: .active, isCalling: false),
            .init(name: "John \(number)",  avatar: "Avatar-2", pronouns: "he/him", availability: .active),
            .init(name: "Zak \(number)",  avatar: "Avatar-3",availability: .active),
            .init(name: "Fernando \(number)",  avatar: "Avatar-4",availability: .active),
            .init(name: "Harriet \(number)",  avatar: "Avatar-5",pronouns: "she/her", availability: .active),
            .init(name: "Kay-Anne \(number)",  avatar: "Avatar-6",availability: .active),
            .init(name: "Charley \(number)",  avatar: "Avatar-7",availability: .active),
            .init(name: "Angela \(number)",  avatar: "Avatar-8",availability: .away),
            .init(name: "TJ \(number)",  avatar: "Avatar-9",pronouns: "they/their",availability: .away),
            .init(name: "Reed \(number)",  avatar: "Avatar-1",availability: .away),
            .init(name: "Dan \(number)",  avatar: "Avatar-2",availability: .away),
        ]
    }
}
