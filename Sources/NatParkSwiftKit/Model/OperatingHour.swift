//
//  OperatingHour.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 2/10/20.
//

import Foundation

/// Hours and seasons when a facility is open or closed
public struct OperatingHour: Decodable {
    /// Name of facility
    public let name: String
    /// Description of facility
    public let description: String
    /// Standard Hour information
    public let standardHours: WeekInfo
    /// Exceptions with regards to Standard Hour information
    public let exceptions: [StandardHourException]?
}

/// Exception to Standard Hour definition for a facility
public struct StandardHourException: Decodable {
    /// Name of Exception, e.g. "1. Spring Closure"
    public let name: String
    /// Start Date, e.g. "2020-03-16"
    public let startDate: String
    /// End Date, e.g. "2020-04-16"
    public let endDate: String
    /// Detailed information per weekday
    public let exceptionHours: WeekInfo
}

/// Detailed hour information per weekday, e.g. "All Day" or "Closed" or "8:00AM - 8:00PM"
public struct WeekInfo: Decodable {
    /// Sunday
    public let sunday: String?
    /// Monday
    public let monday: String?
    /// Tuesday
    public let tuesday: String?
    /// Wednesday
    public let wednesday: String?
    /// Thursday
    public let thursday: String?
    /// Friday
    public let friday: String?
    /// Saturday
    public let saturday: String?
}
