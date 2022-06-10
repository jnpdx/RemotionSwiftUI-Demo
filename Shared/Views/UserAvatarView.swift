//
//  UserAvatarView.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import SwiftUI

struct UserAvatarView: View {
    var user: User
    
    @State private var animationValue: CGFloat = 1.0
    @State private var animationValue2: CGFloat = 1.0
    
    var body: some View {
        Circle()
            .overlay(
                Image(user.avatar!)
                    .resizable()
                    .clipShape(Circle())
            )
            .aspectRatio(1.0, contentMode: .fit)
            .scaleEffect(animationValue)
            .animation(user.isCalling ? .easeInOut(duration: 0.5).repeatForever() : .default, value: animationValue)
            .modifier(Shake(animatableData: animationValue2))
            .animation(user.isCalling ? .easeInOut(duration: 0.1).repeatForever() : .default, value: animationValue2)
            .overlay(
                availability
                    .padding(10)
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .bottomTrailing)
            )
            .onAppear {
                startCallAction()
            }
    }
    
    @ViewBuilder var availability: some View {
        Circle()
            .fill(
                colorForAvailability(user.availability)
            )
            .frame(width: 20,
                   height: 20)
    }
    
    func startCallAction() {
        guard user.isCalling else { return }
        print("Starting call action for \(user)")
        animationValue = 0.8
        animationValue2 = -1
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
                                  isPinned: true))
            .frame(maxHeight: 120)
    }
}
