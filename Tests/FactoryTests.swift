//
//  FactoryTests.swift
//  VCDependency
//
//  Created by Valentin Cherepyanko on 25.11.2020.
//

import XCTest
@testable import VCDependency

private class Mock {
    let uuid = UUID().uuidString
}

private final class Container {
    lazy var mock = Factory { Mock() }
}

final class FactoryTests: XCTestCase {

    private var container: Container!

    override func setUp() {
        container = Container()
    }

    override func tearDown() {
        container = nil
    }

    func test_factory_dependencies() {
        // Arrange
        var mock1: Mock?
        var mock2: Mock?

        // Act
        mock1 = container.mock.get()
        mock2 = container.mock.get()

        // Assert
        XCTAssertNotNil(mock1)
        XCTAssertNotNil(mock2)
        XCTAssertNotEqual(mock1?.uuid, mock2?.uuid)
    }
}
