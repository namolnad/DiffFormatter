//
//  DelimiterPair.swift
//  DiffFormatter
//
//  Created by Dan Loman on 8/17/18.
//  Copyright © 2018 DHL. All rights reserved.
//

import Foundation

struct DelimiterPair: Codable, Equatable {
    let left: String
    let right: String
}

extension DelimiterPair {
    static let defaultInput: DelimiterPair = .init(left: "[", right: "]")
    static let defaultOutput: DelimiterPair = .init(left: "|", right: "|")
    static let empty: DelimiterPair = .init(left: "", right: "")

    var isEmpty: Bool {
        return left.isEmpty ||
        right.isEmpty
    }
}