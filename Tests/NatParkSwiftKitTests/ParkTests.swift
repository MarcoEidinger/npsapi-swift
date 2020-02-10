//
//  ParkTests.swift
//  NatParkSwiftKitTests
//
//  Created by Eidinger, Marco on 1/29/20.
//

import XCTest
import NatParkSwiftKit

class ParkTests: XCTestCase {

    func testMemberwiseInitializer() {
        let park = Park(id: "123", parkCode: "yell", name: "Yellowstone", fullName: "Yellowstone National Park", description: "Left", designation: .nationalPark, states: [.wyoming], gpsLocation: nil, directionsInfo: "", directionsUrl: nil, weatherInfo: "", url: nil, images: [], entranceFees: [], entrancePasses: [], addresses: [], operatingHours: [])
        XCTAssertNotNil(park)
    }

    func testEqualityComparision() {
        let park1 = Park(id: "123", parkCode: "yell", name: "Yellowstone", fullName: "Yellowstone National Park", description: "Left", designation: .nationalPark, states: [.wyoming], gpsLocation: nil, directionsInfo: "", directionsUrl: nil, weatherInfo: "", url: nil, images: [], entranceFees: [], entrancePasses: [], addresses: [], operatingHours: [])
        let park2 = Park(id: "123", parkCode: "yell", name: "Yellowstone", fullName: "Yellowstone National Park", description: "Left", designation: .nationalPark, states: [.wyoming], gpsLocation: nil, directionsInfo: "", directionsUrl: nil, weatherInfo: "", url: nil, images: [], entranceFees: [], entrancePasses: [], addresses: [], operatingHours: [])
        XCTAssertEqual(park1, park2)
    }

    func testHashableConformance() {
        let park = Park(id: "123", parkCode: "yell", name: "Yellowstone", fullName: "Yellowstone National Park", description: "Left", designation: .nationalPark, states: [.wyoming], gpsLocation: nil, directionsInfo: "", directionsUrl: nil, weatherInfo: "", url: nil, images: [], entranceFees: [], entrancePasses: [], addresses: [], operatingHours: [])
        var dictionary: [Park:String] = [:]
        dictionary[park] = "Cool"
        XCTAssertEqual(dictionary[park], "Cool")
    }
}
