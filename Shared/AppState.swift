//
//  State.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var team: Team
    
    private let simulator = StateSimulator()
    
    init() {
        team = StateSimulator.generateSampleTeam()
        simulator.startSimulation(appState: self)
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
            .sorted {
                if $0.availability == .active && $1.availability != .active {
                    return true
                }
                if $0.availability == .focused && $1.availability == .away {
                    return true
                }
                return false
            }
    }
}

extension AppState {
    func userForID(_ userID: UUID) -> User? {
        team.users.first { user in
            user.id == userID
        }
    }
    
    func callForUser(userID: UUID) -> Call? {
        team.calls.first { call in
            call.users.contains(userID)
        }
    }
    
    func inCallWithUsers(forUserID userID: UUID) -> [User] {
        guard let call = callForUser(userID: userID) else {
            return []
        }
        return usersInCall(callID: call.id)
    }
    
    func usersInCall(callID: UUID) -> [User] {
        guard let call = team.calls.first(where: { $0.id == callID }) else {
            return []
        }
        return call.users.compactMap { userForID($0) }
    }
    
    func usersInRoom(roomID: UUID) -> [User] {
        guard let call = team.calls.first(where: { $0.roomID == roomID }) else {
            return []
        }
        return call.users.compactMap { userForID($0) }
    }
}
