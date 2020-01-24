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
}

/// Park basics data includes location, contact, operating hours, and entrance fee/pass information for each national park. At least five photos of each park are also available.
public struct Park: Decodable {
    enum CodingKeys: CodingKey {
        case id, parkCode, name, fullName, description, url, designation, states, latLong, directionsInfo, directionsUrl, weatherInfo, images, entranceFees, entrancePasses
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
}

extension Park {
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
    }
}
