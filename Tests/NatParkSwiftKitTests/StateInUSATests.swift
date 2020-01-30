//
//  StateInUSATests.swift
//  NatParkSwiftKitTests
//
//  Created by Eidinger, Marco on 1/23/20.
//

import XCTest
import NatParkSwiftKit

class StateInUSATests: XCTestCase {

    func testCompleteness() {
        XCTAssertEqual(StateInUSA.allCases.count, 50)
    }

    func testSimpleName() {
        let cali: StateInUSA = .california
        XCTAssertEqual(cali.name, "California")
    }

    func testDoubleName() {
        let newyork: StateInUSA = .newYork
        XCTAssertEqual(newyork.name, "New York")
    }

    func testAbbreviation() {
        let cali: StateInUSA = .california
        XCTAssertEqual(cali.postalAbbreviation, "CA")
    }

}
