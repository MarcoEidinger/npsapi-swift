//
//  Address.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 2/10/20.
//

import Foundation

/// Address Type
public enum AddressType: String, Decodable {
    /// physical
    case physical = "Physical"
    /// mailing
    case mailing = "Mailing"
}

/// Address
public struct Address: Decodable {
    /// type
    public let type: AddressType
    /// postalCode
    public let postalCode: String
    /// City
    public let city: String
    /// US State
    public let stateCode: StateInUSA
    /// line 1
    public let line1: String?
    /// line 2
    public let line2: String?
    /// line 3
    public let line3: String?
}
