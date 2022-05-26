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
                
    //            ForEach(state.unPinnedRooms) { room in
    //                RoomView(users: state.team.users, room: room)
    //            }
                
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
