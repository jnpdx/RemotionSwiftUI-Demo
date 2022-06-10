//
//  Utility.swift
//  RemotionSwiftUI
//
//  Created by John Nastos on 6/9/22.
//

import Foundation

extension Array {
    func safePrefix(_ index: Int) -> ArraySlice<Element> {
        if index >= self.count {
            return self.prefix(through: self.count - 1)
        } else {
            return self.prefix(through: self.count - 1)
        }
    }
    
    func safeSlice(beginning: Int, end: Int) -> ArraySlice<Element> {
        guard beginning < self.count else { return [] }
        guard end < self.count else { return self[beginning...self.count - 1] }
        return self[beginning...end]
    }
}
