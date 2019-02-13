//
//  App.swift
//  FinchApp
//
//  Created by Dan Loman on 1/13/19.
//  Copyright © 2019 DHL. All rights reserved.
//

import struct Utility.Version
import FinchCore
import FinchUtilities

typealias Version = Utility.Version

public struct App {
    public typealias Options = AppOptions

    public struct Meta {
        public typealias Version = Utility.Version

        let buildNumber: Int
        let name: String
        let version: Version

        public init(buildNumber: Int, name: String, version: Version) {
            self.buildNumber = buildNumber
            self.name = name
            self.version = version
        }
    }

    public let configuration: Configuration
    public let meta: Meta
    public let options: Options
    private let output: OutputType

    init(configuration: Configuration, meta: Meta, options: Options, output: OutputType = Output.instance) {
        self.configuration = configuration
        self.meta = meta
        self.options = options
        self.output = output
    }

    func print(_ value: String, kind: Output.Kind = .default) {
        output.print(value, kind: kind, verbose: options.verbose)
    }
}
