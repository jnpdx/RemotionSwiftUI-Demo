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
    
    @State private var animationValue: CGFloat = 1.0
    @State private var animationValue2: CGFloat = 1.0
    
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
                    HStack {
                        ForEach(otherUsersDisplay) { otherUser in
                            switch otherUser {
                            case .user(let user):
                                Image(user.avatar!)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 20, height: 20)
                                    .shadow(radius: 4.0)
                            case .number(let number):
                                Text("\(number)")
                                    .background(Circle().fill(.white)                                    .frame(width: 20, height: 20))
                            }
                        }
                    }
                }
                
            )
            .aspectRatio(1.0, contentMode: .fit)
            .scaleEffect(animationValue)
            .animation(user.isCalling ? .easeInOut(duration: 0.5).repeatForever() : .default, value: animationValue)
            .modifier(Shake(animatableData: animationValue2))
            .animation(user.isCalling ? .easeInOut(duration: 0.1).repeatForever() : .default, value: animationValue2)
            .onAppear {
                respondToCallState(user: user)
            }
            .onChange(of: user) { user in
                respondToCallState(user: user)
            }
    }
    
    @ViewBuilder var availability: some View {
        GeometryReader { proxy in
            Circle()
                .fill(
                    colorForAvailability(user.availability)
                )
                .frame(width: proxy.size.width / 5,
                       height: proxy.size.height / 5)
        }
    }
    
    func respondToCallState(user: User) {
        if user.isCalling {
            animationValue = 0.8
            animationValue2 = -1
        } else {
            animationValue = 1.0
            animationValue2 = 1.0
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

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX:
            amount * animatableData,
            y: 0)
        )
    }
}

struct UserAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatarView(user: User(id: UUID(),
                                  name: "Fernando",
                                  avatar: nil,
                                  status: nil,
                                  pronouns: nil,
                                  availability: .active,
                                  isCalling: true,
                                  isPinned: true), inCallWithUsers: [])
            .frame(maxHeight: ITEM_HEIGHT)
    }
}
