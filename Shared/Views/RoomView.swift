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
    
    @State private var roomInfoShown = false
    @State private var viewHeight: CGFloat = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(colors: [room.color, .white],
                               startPoint: .bottomLeading,
                               endPoint: .topTrailing)
                )
            .aspectRatio(1.0, contentMode: .fit)
            .background(GeometryReader {
                Color.clear.preference(key: ViewHeightKey.self,
                                       value: $0.frame(in: .local).size.height)
            })
            .onPreferenceChange(ViewHeightKey.self) {
                viewHeight = $0
            }
            .overlay(
                ZStack {
                    Text(room.emoji ?? "")
                        .font(.system(size: viewHeight / 2))
                    userIndicator
                }
            )
            .onHover(perform: { hovering in
                roomInfoShown = hovering
            })
            .popover(isPresented: $roomInfoShown, arrowEdge: .leading) {
                VStack(alignment: .leading) {
                    Text(room.name)
                        .fontWeight(.bold)
                    if !users.isEmpty {
                        VStack(alignment: .leading) {
                            Text(users.map(\.name), format: .list(type: .and))
                        }
                    }
                }
                .padding()
            }
    }
    
    @ViewBuilder var userIndicator: some View {
        if !users.isEmpty, room.isPinned {
            VStack {
                Text("\(users.count)")
                    .padding(8)
                    .foregroundColor(.black)
            }
            .background(
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(Color.white)
                    .aspectRatio(1.0, contentMode: .fit)
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
                            color: .blue))
    }
}
