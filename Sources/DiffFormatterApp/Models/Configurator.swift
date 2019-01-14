//
//  Configurator.swift
//  DiffFormatterApp.swift
//
//  Created by Dan Loman on 8/14/18.
//  Copyright © 2018 DHL. All rights reserved.
//

import DiffFormatterCore
import DiffFormatterRouting
import DiffFormatterTelemetry
import DiffFormatterUtilities
import Foundation

struct Configurator {
    var configuration: Configuration {
        return getConfiguration()
    }

    // Paths for which the configurator should continue to modify the existing config with the next found config
    private let cascadingPaths: [String]

    private let configResolver: FileResolver<Configuration>

    private let defaultConfig: Configuration

    // Paths for which the configurator should return the first valid configuration
    private let immediateReturnPaths: [String]

    init(processInfo: ProcessInfo, argScheme: ArgumentScheme, fileManager: FileManager = .default) {
        self.configResolver = .init(fileManager: fileManager, pathComponent: "/.diffformatter/config.json", logError: log.error)
        self.defaultConfig = .default(currentDirectory: fileManager.currentDirectoryPath)

        let immediateReturnPaths = [
            processInfo.environment["DIFFFORMATTER_CONFIG"]
        ]

        self.immediateReturnPaths = immediateReturnPaths
            .compactMap { $0 }
            .filter { !$0.isEmpty }

        let homeDirectoryPath: String
        if #available(OSX 10.12, *) {
            homeDirectoryPath = fileManager.homeDirectoryForCurrentUser.path
        } else {
            homeDirectoryPath = NSHomeDirectory()
        }

        var cascadingPaths = [
            homeDirectoryPath,
            fileManager.currentDirectoryPath
        ]

        // Append project dir if passed in as argument
        for case let .actionable(.projectDir, value) in argScheme.args {
            cascadingPaths.append(value)
            break
        }

        self.cascadingPaths = cascadingPaths.filter { !$0.isEmpty }
    }

    private func getConfiguration() -> Configuration {
        // Start with default configuration
        var configuration = defaultConfig

        if let config = immediateReturnPaths.firstMap(configResolver.resolve) {
            configuration.update(with: config)
            return configuration
        }

        for config in cascadingPaths.compactMap(configResolver.resolve) where !config.isBlank {
            configuration.update(with: config)
        }

        return configuration
    }
}