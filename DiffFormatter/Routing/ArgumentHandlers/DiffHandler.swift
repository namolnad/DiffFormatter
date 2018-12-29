//
//  DiffHandler.swift
//  DiffFormatter
//
//  Created by Dan Loman on 11/5/18.
//  Copyright © 2018 DHL. All rights reserved.
//

import Foundation

extension ArgumentRouter {
    static let diffHandler: RouterArgumentHandling = .init { context, scheme in
        guard let oldVersion = scheme.oldVersion, let newVersion = scheme.newVersion else {
            return .notHandled
        }

        let hideHeader = scheme.args.contains(.flag(.noShowVersion))
        var versionHeader: String? = hideHeader ? nil : scheme.newVersion
        for case let .actionable(.buildNumber, buildNumber) in scheme.args where !hideHeader {
            versionHeader?.append(" (\(buildNumber))")
            break
        }

        var releaseManager: Contributor?
        for case let .actionable(.releaseManager, email) in scheme.args {
            releaseManager = context.configuration.contributors.first { $0.email == email }
            break
        }

        var projectDir: String = context.configuration.currentDirectory
        for case let .actionable(.projectDir, dir) in scheme.args {
            projectDir = dir
            break
        }

        var manualDiff: String?
        for case let .actionable(.gitDiff, diff) in scheme.args {
            manualDiff = diff
            break
        }

        let rawDiff = manualDiff ??
            Utilities.GitDiffer(configuration: context.configuration,
                      projectDir: projectDir,
                      oldVersion: oldVersion,
                      newVersion: newVersion).diff

        let outputGenerator: Utilities.OutputGenerator = .init(
            configuration: context.configuration,
            rawDiff: rawDiff,
            version: versionHeader,
            releaseManager: releaseManager
        )

        context.output(output(generator: outputGenerator))

        return .handled
    }

    private static func output(generator: Utilities.OutputGenerator) -> String {
        let result = generator.generateOutput()

        Utilities.pbCopy(text: result)

        return "Output copied to pasteboard: \(result)"
    }
}
