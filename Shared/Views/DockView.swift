//
//  DockView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation
import SwiftUI

var ITEM_HEIGHT: CGFloat = 80

struct DockView: View {
    @ObservedObject var state: AppState
    
    var body: some View {
        ScrollView {
            VStack {
                //TODO: user avatar
                
                //rooms
                ForEach(state.pinnedRooms) { room in
                    RoomView(users: state.team.users, room: room) // TODO: add call info
                        .frame(maxHeight: ITEM_HEIGHT)
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxHeight: ITEM_HEIGHT)
                    .overlay(
                        VStack {
                            HStack {
                                ForEach(Array(state.unPinnedRooms.safeSlice(beginning: 0, end: 2))) { room in
                                    RoomView(users: state.team.users, room: room)
                                }
                            }
                            .frame(maxHeight: 60)
                            HStack {
                                ForEach(Array(state.unPinnedRooms.safeSlice(beginning: 3, end: 4))) { room in
                                    RoomView(users: state.team.users, room: room)
                                }
                            }
                            .frame(maxHeight: 60)
                        }
                    )
                
                
                Divider()
                
                // Converting to a plain `VStack` seems to solve the issues getting stuck
                LazyVStack {
                    ForEach(state.pinnedUsers) { user in
                        UserAvatarView(user: user)
                            .frame(maxHeight: ITEM_HEIGHT)
                    }
                }
                
                //pinned users
            }
        }
    }
}

struct DockView_Preview: PreviewProvider {
    static var previews: some View {
        let state = AppState()
        DockView(state: state)
    }
}
