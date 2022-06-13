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
        case toggleAvailability
    }
    
    static func generateSampleTeam() -> Team {
        let users: [User] = (1...1).map { User.testUserSet(number: $0) }.flatMap { $0 }
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
        cancelable = Timer.publish(every: 0.3, on: .main, in: .common)
            .autoconnect()
            .map { (_) -> Team in
                guard var user = appState.team.users.randomElement() else {
                    return appState.team
                }
                var team = appState.team
                
                let action = Actions.allCases.randomElement()!
                
                switch action {
                case .toggleCalling:
                    user.isCalling.toggle()
                case .joinRoom:
                    guard let randomRoom = team.rooms.randomElement() else {
                        break
                    }
                    
                    // remove the user from any other calls
                    team.calls = team.calls.map { call in
                        if call.users.contains(user.id) {
                            var copy = call
                            copy.users.removeAll(where: { $0 == user.id })
                            return copy
                        }
                        return call
                    }
                    
                    // is there already a call
                    if var call = team.calls.first(where: { $0.roomID == randomRoom.id }) {
                        call.users.append(user.id)
                        team.calls = team.calls.map { $0.id == call.id ? call : $0 }
                    } else {
                        let call = Call(id: UUID(), users: [user.id], roomID: randomRoom.id)
                        team.calls.append(call)
                    }
                    user.availability = .active
                    
                case .joinCall:
                    guard let randomUser = team.users.randomElement() else {
                        break
                    }
                    
                    // remove the users from any other calls
                    team.calls = team.calls.map { call in
                        if call.users.contains(user.id) || call.users.contains(randomUser.id) {
                            var copy = call
                            copy.users.removeAll(where: { $0 == user.id || $0 == randomUser.id })
                            return copy
                        }
                        return call
                    }
                    
                    team.calls.append(Call(id: UUID(), users: [user.id, randomUser.id], roomID: nil))
                    user.availability = .active
                    
                case .toggleAvailability:
                    user.availability = User.Availability.allCases.randomElement()!
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
}