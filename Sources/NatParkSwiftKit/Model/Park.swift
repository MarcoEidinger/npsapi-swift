//
//  File.swift
//
//
//  Created by Eidinger, Marco on 1/16/20.
//

import Foundation
import CoreLocation

/// Requestable attribute of Park model
public enum RequestableParkField: String, RequestableField {
    /// Park images
    case images
    /// Fee for entering the park
    case entranceFees
    /// Passes available to provide entry into the park
    case entrancePasses
    /// Park addresses (physical and mailing)
    case addresses
    /// Hours and seasons when the park is open or closed
    case operatingHours
    /// Information about contacting staff at the facility
    case contacts
}

/// Park basics data includes location, contact, operating hours, and entrance fee/pass information for each national park. At least five photos of each park are also available.
public struct Park: Decodable, Identifiable, Hashable {

    enum CodingKeys: CodingKey {
        case id, parkCode, name, fullName, description, url, designation, states, latLong, directionsInfo, directionsUrl, weatherInfo, images, entranceFees, entrancePasses, addresses, operatingHours, contacts
    }

    /// Park identification string
    public let id: String
    /// A variable width character code used to identify a specific park
    public let parkCode: String
    /// Short park name (no designation)
    public let name: String
    /// Full park name (with designation)
    public let fullName: String
    /// Introductory paragraph from the park homepage
    public let description: String
    /// Type of designation (eg, national park, national monument, national recreation area, etc)
    public let designation: ParkUnitDesignation
    /// State(s) the park is located in
    public let states: [StateInUSA]
    /// Park GPS cordinates
    public let gpsLocation: CLLocation?
    /// General overview of how to get to the park
    public let directionsInfo: String
    /// Link to page, if available, that provides additional detail on getting to the park
    public let directionsUrl: URL?
    /// General description of the weather in the park over the course of a year
    public let weatherInfo: String?
    /// Park Website
    public let url: URL?
    /// Park images
    public let images: [NpsImage]?
    /// Fee for entering the park
    public let entranceFees: [Fee]?
    /// Passes available to provide entry into the park
    public let entrancePasses: [Fee]?
    /// Park addresses (physical and mailing)
    public let addresses: [Address]?
    /// Hours and seasons when the park is open or closed
    public let operatingHours: [OperatingHour]?
    /// Information about contacting staff at the facility
    public let contacts: ContactInformation?

    /// Memberwise Initializer
    public init(id: String, parkCode: String, name: String, fullName: String, description: String, designation: ParkUnitDesignation, states: [StateInUSA], gpsLocation: CLLocation?, directionsInfo: String, directionsUrl: URL?, weatherInfo: String?, url: URL?, images: [NpsImage]?, entranceFees: [Fee]?, entrancePasses: [Fee]?, addresses: [Address]?, operatingHours: [OperatingHour]?, contacts: ContactInformation?) {
        self.id = id
        self.parkCode = parkCode
        self.name = name
        self.fullName = fullName
        self.description = description
        self.designation = designation
        self.states = states
        self.gpsLocation = gpsLocation
        self.directionsInfo = directionsInfo
        self.directionsUrl = directionsUrl
        self.weatherInfo = weatherInfo
        self.url = url
        self.images = images
        self.entranceFees = entranceFees
        self.entrancePasses = entrancePasses
        self.addresses = addresses
        self.operatingHours = operatingHours
        self.contacts = contacts
    }

    /// Park can be compared for equality using the equal-to operator (`==`) or inequality using the not-equal-to operator (`!=`)
    public static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.id == rhs.id
    }

    /// Park conforms to the Hashable protocol and hence can be used in a set or as a dictionary key
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension Park {
    /// Decoderwise Initializer
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        name = try values.decode(String.self, forKey: .name)
        fullName = try values.decode(String.self, forKey: .fullName)
        description = try values.decode(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
        designation = try ParkUnitDesignation(validDesignationOrUnknown: values.decodeIfPresent(String.self, forKey: .designation))
        directionsInfo = try values.decode(String.self, forKey: .directionsInfo)
        directionsUrl = try values.decodeIfPresent(String.self, forKey: .directionsUrl)?.toURL()
        weatherInfo = try values.decodeIfPresent(String.self, forKey: .weatherInfo)
        states = try values.decode(String.self, forKey: .states).toStates()
        gpsLocation = try values.decodeIfPresent(String.self, forKey: .latLong)?.toLocation()
        images = try values.decodeIfPresent([NpsImage].self, forKey: .images)
        entranceFees = try values.decodeIfPresent([Fee].self, forKey: .entranceFees)
        entrancePasses = try values.decodeIfPresent([Fee].self, forKey: .entrancePasses)
        addresses = try values.decodeIfPresent([Address].self, forKey: .addresses)
        operatingHours = try values.decodeIfPresent([OperatingHour].self, forKey: .operatingHours)
        contacts = try values.decodeIfPresent(ContactInformation.self, forKey: .contacts)
    }
}
