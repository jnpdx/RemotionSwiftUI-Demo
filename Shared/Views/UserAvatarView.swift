//
//  UserAvatarView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

struct UserAvatarView: View {
    var user: User
    var inCallWithUsers: [User]

    @State private var userInfoShown = false
    
    enum OtherUser: Identifiable {
        case user(User)
        case number(Int)
        
        var id: UUID {
            switch self {
            case .user(let user):
                return user.id
            case .number:
                return UUID()
            }
        }
    }
    
    var otherUsersDisplay: [OtherUser] {
        if inCallWithUsers.count > 2 {
            var usersToDisplay = inCallWithUsers[0...1].map { OtherUser.user($0) }
            usersToDisplay.append(OtherUser.number(inCallWithUsers.count - 2))
            return usersToDisplay
        }
        return inCallWithUsers.map { OtherUser.user($0) }
    }
    
    var body: some View {
        Circle()
            .overlay(
                ZStack {
                    Image(user.avatar!)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(1.0, contentMode: .fit)
                        .overlay(
                            availability
                                .padding(10)
                                .frame(maxWidth: .infinity,
                                       maxHeight: .infinity,
                                       alignment: .bottomTrailing)
                        )
                        .opacity(user.availability == .away ? 0.4 : 1.0)
                        .saturation(user.availability == .away ? 0.1 : 1.0)
                        .onHover(perform: { hovering in
                            userInfoShown = hovering
                        })
                    HStack {
                        ForEach(otherUsersDisplay) { otherUser in
                            VStack {
                                switch otherUser {
                                case .user(let user):
                                    Image(user.avatar!)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 20, height: 20)
                                        .shadow(radius: 4.0)
                                case .number(let number):
                                    Text("\(number)")
                                        .frame(width: 20, height: 20)
                                        .background(Circle().fill(.white) .shadow(radius: 4.0))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                    if user.isCalling {
                        // show the calling signal
                        CallingSignalView()
                    }
                }
            )
            .aspectRatio(1.0, contentMode: .fit)
            .popover(isPresented: $userInfoShown, arrowEdge: .leading) {
                VStack(alignment: .leading) {
                    Text(user.name)
                        .fontWeight(.bold)
                    if let pronouns = user.pronouns {
                        Text(pronouns)
                    }
                    if !inCallWithUsers.isEmpty {
                        VStack(alignment: .leading) {
                            Text("In a call with: ")
                            Text(inCallWithUsers.map(\.name), format: .list(type: .and))
                        }
                    }
                }
                .padding()
            }
    }
    
    @ViewBuilder var availability: some View {
        GeometryReader { proxy in
            if inCallWithUsers.isEmpty {
                Circle()
                    .fill(
                        colorForAvailability(user.availability)
                    )
                    .frame(width: proxy.size.width / 5,
                           height: proxy.size.height / 5)
            }
        }
    }
    
    func colorForAvailability(_ availability: User.Availability) -> Color {
        switch availability {
        case .away:
            return .yellow
        case .active:
            return .green
        case .focused:
            return .purple
        }
    }
}

struct CallingSignalView : View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .fill(Color.red.opacity(0.5))
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut.repeatForever(autoreverses: true)) {
                    scale = 0.2
                }
            }
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView(user: User(id: UUID(),
                                  name: "Fernando",
                                  avatar: User.randomAvatarImageName,
                                  status: nil,
                                  pronouns: nil,
                                  availability: .away,
                                  isCalling: false,
                                  isPinned: true),
                       inCallWithUsers: [
                        User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false),
                        User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false),
                        User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false)
                       ])
            .frame(maxHeight: ITEM_HEIGHT)
            .border(Color.blue)
    }
}
