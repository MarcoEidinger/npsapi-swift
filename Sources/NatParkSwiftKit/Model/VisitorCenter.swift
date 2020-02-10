//
//  VisitorCenter.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 1/23/20.
//

import Foundation
import CoreLocation

/// Requestable attribute of VisitorCenter model
public enum RequestableVisitorCenterField: String, RequestableField {
    /// Visitor Center addresses (physical and mailing)
    case addresses
    /// Hours and seasons when the visitor center is open or closed
    case operatingHours

    case contacts
}

/// Visitor center data includes location, contact, and operating hours information for visitor centers and other visitor contact facilities in national parks At least one visitor center is listed for each park; some parks with multiple visitor centers may include information about more than one
public struct VisitorCenter: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id, parkCode, name, description, directionsInfo, directionsUrl, latLong, addresses, operatingHours, contacts
    }

    /// ID
    public let id: String
    /// A variable width character code used to identify a specific park
    public let parkCode: String
    /// News release title
    public let name: String
    /// General description of the facility
    public let description: String
    /// Date news release was released
    public let directionsInfo: String?
    /// Link to full news release
    public let directionsUrl: URL?
    /// News release image
    public let gpsLocation: CLLocation?
    /// Visitor Center addresses (physical and mailing)
    public let addresses: [Address]?
    /// Hours and seasons when the visitor center is open or closed
    public let operatingHours: [OperatingHour]?

    public let contacts: ContactInformation?
}

extension VisitorCenter {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        directionsInfo = try values.decodeIfPresent(String.self, forKey: .directionsInfo)
        directionsUrl = try values.decodeIfPresent(String.self, forKey: .directionsUrl)?.toURL()
        gpsLocation = try values.decodeIfPresent(String.self, forKey: .latLong)?.toLocation()
        addresses = try values.decodeIfPresent([Address].self, forKey: .addresses)
        operatingHours = try values.decodeIfPresent([OperatingHour].self, forKey: .operatingHours)
        contacts = try values.decodeIfPresent(ContactInformation.self, forKey: .contacts)
    }
}
