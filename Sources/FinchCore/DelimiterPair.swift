//
//  DelimiterPair.swift
//  Finch
//
//  Created by Dan Loman on 8/17/18.
//  Copyright © 2018 DHL. All rights reserved.
//

import Foundation

public struct DelimiterPair: Codable, Equatable {
    public let left: String
    public let right: String
}

/// :nodoc:
extension DelimiterPair {
    static let defaultInput: DelimiterPair = .init(left: "[", right: "]")
    static let defaultOutput: DelimiterPair = .init(left: "|", right: "|")
    static let blank: DelimiterPair = .init(left: "", right: "")
}

/// :nodoc:
extension DelimiterPair {
    var isBlank: Bool {
        return left.isEmpty ||
            right.isEmpty
    }
}
