//
//  GridDockView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 6/14/22.
//

import Foundation
import SwiftUI

struct GridDockView : View {
    @ObservedObject var state: AppState
    
    private let userColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(128), spacing: 10)]) {
                    ForEach(state.pinnedRooms) { room in
                        RoomView(users: state.usersInRoom(roomID: room.id),
                                 room: room
                        )
                        .aspectRatio(1.0, contentMode: .fit)
                    }
                }
                .padding()
            }
            LazyVGrid(columns: userColumns) {
                ForEach(state.pinnedUsers) { user in
                    UserAvatarView(user: user, inCallWithUsers: state.inCallWithUsers(forUserID: user.id))
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
            .padding()
        }
    }
}
