//
//  ConfigurationTests.swift
//  FinchTests
//
//  Created by Dan Loman on 12/28/18.
//  Copyright © 2018 DHL. All rights reserved.
//

@testable import FinchApp
import SnapshotTesting
import XCTest

final class ConfigurationTests: XCTestCase {
    func testConfigurator() {
        assertSnapshot(
            matching: Configurator(
                options: .blank,
                meta: .mock,
                environment: [:],
                fileManager: .mock
            ).configuration,
            as: .dump
        )
    }
}
