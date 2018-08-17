//
//  FindReplacePatterns.swift
//  DiffFormatter
//
//  Created by Dan Loman on 7/5/18.
//  Copyright © 2018 DHL. All rights reserved.
//

import Foundation

typealias FindReplacePattern = (text: String, replacement: String)

struct FindReplacePatternCreator {
    private let configuration: Configuration

    var patterns: [[FindReplacePattern]] {
        return [
            exclusionPatterns,
            authorPatterns,
            formattingPatterns,
            linkPatterns,
        ]
    }

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    private var exclusionPatterns: [FindReplacePattern] {
        let inputDelimiters = configuration.delimiterConfig.input

        return [
            ("^(.*)(@@@(.*)@@@)(.*)(\n(.*)\\2(.*))+$", ""),
            ("^<(.*)$", ""),
            ("^(.*)@@@\(inputDelimiters.left.escaped)version\(inputDelimiters.right.escaped)(.*)$", ""),
        ]
    }

    private var formattingPatterns: [FindReplacePattern] {
        let inputDelimiters = configuration.delimiterConfig.input
        let outputDelimiters = configuration.delimiterConfig.output

        return [
            (inputDelimiters.left.escaped, outputDelimiters.left.escaped),
            (inputDelimiters.right.escaped, outputDelimiters.right.escaped),
            ("^>", " -"),
        ]
    }

    private let linkPatterns: [FindReplacePattern] = [
        ("&&&(.*)&&&(.*)@@@(.*)\\(#(.*)\\)@@@", "$3— [PR #$4](https://github.com/instacart/instacart-ios/pull/$4) —"),
        ("&&&(.*)&&&(.*)@@@(.*)@@@", "$3 — [Commit](https://github.com/instacart/instacart-ios/commit/$1) —")
    ]

    private var authorPatterns: [FindReplacePattern] {
        let prefix = configuration.userHandlePrefix.escaped
        return configuration.users.compactMap { FindReplacePattern(text: "###\($0.email.escaped)###", replacement: " \(prefix)\($0.userHandle.escaped)") }
    }
}
