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
                //user avatar
                
                //rooms
                ForEach(state.pinnedRooms) { room in
                    RoomView(users: state.team.users, room: room)
                        .frame(maxHeight: 120)
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(maxHeight: 120)
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
                
                ForEach(state.pinnedUsers) { user in
                    UserAvatarView(user: user)
                        .frame(maxHeight: 120)
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
