//
//  Room.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 5/25/22.
//

import Foundation
import SwiftUI

struct Room: Identifiable {
    var id = UUID()
    var name: String
    var avatar: String?
    var color: Color
    
    var users: [UUID]
    var isPinned: Bool = true
}
