//
//  UserAvatarView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

struct SentEmoji: Identifiable, Hashable {
    var id = UUID()
    var emoji: String
}

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
                        .opacity(user.availability == .away ? 0.4 : 1.0)
                        .saturation(user.availability == .away ? 0.1 : 1.0)
                        .overlay(
                            Circle()
                                .strokeBorder(user.isTalking ? .red : .clear,
                                              lineWidth: user.isTalking ? 4 : 0)
                        )
                    HStack {
                        availability
                            .frame(width: 20, height: 20)
                            .padding(2)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
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
                                        .overlay(
                                            Circle()
                                                .strokeBorder(user.isTalking ? .red : .clear,
                                                              lineWidth: user.isTalking ? 1 : 0)
                                        )
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
                    
                    if let emoji = user.sentEmoji {
                        SentEmojiView(emoji: emoji)
                            .id(emoji.id)
                    }
                }
            )
            .aspectRatio(1.0, contentMode: .fit)
            .onTapGesture {
                userInfoShown.toggle()
            }
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
        if inCallWithUsers.isEmpty {
            Circle()
                .fill(
                    colorForAvailability(user.availability)
                )
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

struct SentEmojiView : View {
    var emoji: SentEmoji
    @State private var opacity : CGFloat = 1.0
    @State private var scale : CGFloat = 0.5
    
    var body: some View {
        Text(emoji.emoji)
            .font(.system(size: 80))
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeOut(duration: 4.0)) {
                    opacity = 0.0
                    scale = 1.5
                }
            }
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        let otherUsers = [
            User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false),
            User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false),
            User(id: UUID(), name: "A", avatar: User.randomAvatarImageName, status: nil, pronouns: nil, availability: .active, isCalling: false, isPinned: false)
           ]
        
        UserAvatarView(user: User(id: UUID(),
                                  name: "Fernando",
                                  avatar: User.randomAvatarImageName,
                                  status: nil,
                                  pronouns: nil,
                                  availability: .active,
                                  isCalling: false,
                                  isPinned: true),
                       inCallWithUsers: otherUsers)
            .frame(maxHeight: ITEM_HEIGHT)
            .border(Color.blue)
    }
}
