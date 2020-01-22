//
//  Fee.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/22/20.
//

import Foundation

/// Fee information, e.g park entrance fee or par entrance pass fee
public struct Fee: Decodable {
    /// Fee amount in US Dollar
    public let cost: String?
    /// Description of what the fee includes
    public let description: String?
    /// Title of Fee
    public let title: String?
}
