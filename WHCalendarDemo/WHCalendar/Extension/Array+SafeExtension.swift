//
//  BoundSafe.swift
//  WHBaseFramework
//
//  Created by 王红 on 2022/4/24.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

