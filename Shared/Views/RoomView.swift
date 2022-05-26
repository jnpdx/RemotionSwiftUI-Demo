//
//  RoomView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

struct RoomView: View {
    var users: [User]
    var room: Room
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(colors: [room.color, .white],
                               startPoint: .bottomLeading,
                               endPoint: .topTrailing)
                )
            .aspectRatio(1.0, contentMode: .fit)
            .overlay(
                userIndicator
            )
    }
    
    @ViewBuilder var userIndicator: some View {
        if room.users.count != 0 {
            VStack {
                Text("\(room.users.count)")
                    .padding(8)
            }.background(
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(Color.white)
            )
            
                .padding(4)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomTrailing)
        } else {
            EmptyView()
        }
    }
}

struct RoomView_Previews: PreviewProvider {
    static var previews: some View {
        RoomView(users: [],
                 room: Room(name: "",
                            color: .blue,
                            users: []))
    }
}
