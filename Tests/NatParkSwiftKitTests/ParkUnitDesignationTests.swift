//
//  ParkUnitDesignationTests.swift
//  NatParkSwiftKitTests
//
//  Created by Eidinger, Marco on 1/24/20.
//

import XCTest
import NatParkSwiftKit

class ParkUnitDesignationTests: XCTestCase {

    func testAllCases() {
        let values = ParkUnitDesignation.allCases.map {$0.rawValue}
        XCTAssertEqual(ParkUnitDesignation.allCases.count, values.count)
    }

    func testValidInit() {
        XCTAssertNotNil(ParkUnitDesignation(validDesignationOrUnknown: "National Park"))
    }

    func testInitFallbackToUnknown() {
        XCTAssertEqual(ParkUnitDesignation(validDesignationOrUnknown: "XXXX"), ParkUnitDesignation.unknown)
    }

}
