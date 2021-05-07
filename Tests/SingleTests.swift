//
//  SingleTests.swift
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
    lazy var mock = Single { Mock() }
}

final class SingleTests: XCTestCase {

    private var container: Container!

    override func setUp() {
        container = Container()
    }

    override func tearDown() {
        container = nil
    }

    func test_single_different_dependencies() {
        // Arrange
        var mock1: Mock?
        var mock2: Mock?

        // Act
        mock1 = container.mock.get()
        mock2 = container.mock.get()

        // Assert
        XCTAssertNotNil(mock1)
        XCTAssertNotNil(mock2)
        XCTAssertEqual(mock1?.uuid, mock2?.uuid)
    }

    func test_single_object_lifecycle() {
        // Arrange
        var mock: Mock?

        // Act
        mock = container.mock.get()
        let previousUuid = mock?.uuid
        mock = nil
        mock = container.mock.get()

        // Assert
        XCTAssertNotNil(mock)
        XCTAssertEqual(previousUuid, mock?.uuid)
    }
}
