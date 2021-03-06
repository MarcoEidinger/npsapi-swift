//
//  RequestOption.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 1/17/20.
//

import Foundation

/// Generic options to influence or restrict the amount of data to be fetched from the National Park Service API
public struct RequestOptions<T: RequestableField> {
    /// Number of results to return per request. Default is 50.
    public var limit: Int? = 50
    /// Pagination: get the next [limit] results starting with this number
    public var start: Int? = 0
    /// Term to search on
    public let searchQuery: String?
    /// List of resource properties to include in the  response in addition to the default properties
    public let fields: [T]?
}
