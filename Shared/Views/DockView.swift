//
//  DockView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation
import SwiftUI

struct DockView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ScrollView {
            VStack {
                //TODO: user avatar
                
                roomsViews
                
                // unpinnedRoomsView
                
                Divider()
                
                LazyVStack {
                    pinnedUsersViews
                }
            }
            .padding()
        }
    }
    
    var roomsViews: some View {
        ForEach(state.pinnedRooms) { room in
            RoomView(users: state.usersInRoom(roomID: room.id),
                     room: room
            )
            .aspectRatio(1.0, contentMode: .fit)
        }
    }
    
    var unpinnedRoomsView: some View {
        RoundedRectangle(cornerRadius: 20)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                // TODO: LazyGrid
                VStack {
                    HStack {
                        ForEach(Array(state.unPinnedRooms.safeSlice(beginning: 0, end: 2))) { room in
                            RoomView(users: state.usersInRoom(roomID: room.id), room: room)
                        }
                    }
                    .frame(maxHeight: 60)
                    HStack {
                        ForEach(Array(state.unPinnedRooms.safeSlice(beginning: 3, end: 4))) { room in
                            RoomView(users: state.usersInRoom(roomID: room.id), room: room)
                        }
                    }
                    .frame(maxHeight: 60)
                }
            )
    }
    
    var pinnedUsersViews: some View {
        ForEach(state.pinnedUsers) { user in
            UserAvatarView(user: user, inCallWithUsers: state.inCallWithUsers(forUserID: user.id))
                .aspectRatio(1.0, contentMode: .fit)
        }
    }
}

struct DockView_Preview: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        DockView(state: state)
    }
}
