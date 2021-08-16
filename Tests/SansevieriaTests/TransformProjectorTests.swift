//
//  TransformProjectorTests.swift
//

import XCTest
@testable import Sansevieria

class TransformProjectorTests: XCTestCase {

    class LinearProjector: Projector {
        func value(at time: TimeInterval) -> CGFloat {
            CGFloat(time)
        }
        var duration: TimeInterval = 1.0
    }

    var source: some Projector {
        FormulaProjector.linear
    }

    func testPlane() {
        let result = TransformProjector(source: source)

        XCTAssertEqual(result.duration, source.duration)
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 0.5), source.value(at: 0.5))
        XCTAssertEqual(result.value(at: 1.0), source.value(at: 1.0))
    }

    func testDelay () {
        let result = TransformProjector(source: source)
            .delay(1.0)

        XCTAssertEqual(result.duration, source.duration + 1.0)
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 0.5), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 1.0), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 1.5), source.value(at: 0.5))
        XCTAssertEqual(result.value(at: 2.0), source.value(at: 1.0))
    }

    func testStretch() {
        let result = TransformProjector(source: source)
            .stretch(2.0)

        XCTAssertEqual(result.duration, 2.0)
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 1.0), source.value(at: 0.5))
        XCTAssertEqual(result.value(at: 2.0), source.value(at: 1.0))
    }

    func testCutHead() {
        let result = TransformProjector(source: source)
            .cut(head: 0.5)

        XCTAssertEqual(result.duration, source.duration - 0.5)
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.5))
        XCTAssertEqual(result.value(at: 0.5), source.value(at: 1.0))
    }

    func testCutTail() {
        let result = TransformProjector(source: source)
            .cut(tail: 0.5)

        XCTAssertEqual(result.duration, source.duration - 0.5)
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.0))
        XCTAssertEqual(result.value(at: 0.5), source.value(at: 0.5))
    }

    func testCutHeadTail() {
        let result = TransformProjector(source: source)
            .cut(head: 0.2, tail: 0.2)

        XCTAssertEqual(result.duration, source.duration - 0.4)
        XCTAssertEqual(result.value(at: -0.2), source.value(at: 0.2))
        XCTAssertEqual(result.value(at: 0.0), source.value(at: 0.2))
        XCTAssertEqual(result.value(at: 0.6), source.value(at: 0.8))
        XCTAssertEqual(result.value(at: 1.0), source.value(at: 0.8))
    }
}
