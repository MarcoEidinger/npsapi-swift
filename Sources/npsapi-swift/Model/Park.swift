//
//  File.swift
//  
//
//  Created by Eidinger, Marco on 1/16/20.
//

import Foundation

/// Requestable attribute of Park model
public enum RequestableParkField: String, RequestableField {
    /// Park identification string
    case id
    /// A variable width character code used to identify a specific park
    case parkCode
    /// Short park name (no designation)
    case name
    /// Full park name (with designation)
    case FullName
    /// Introductory paragraph from the park homepage
    case description
    /// Type of designation (eg, national park, national monument, national recreation area, etc)
    case designation
    /// State(s) the park is located in
    case states
    /// General overview of how to get to the park
    case directionsInfo
    /// General description of the weather in the park over the course of a year
    case weatherInfo

//    /// Returns raw value, i.e. string
//    public var debugDescription: String {
//        return self.rawValue
//    }
}

/// Park basics data includes location, contact, operating hours, and entrance fee/pass information for each national park. At least five photos of each park are also available.
public struct Park: Decodable {
    enum CodingKeys: CodingKey {
      case id, parkCode, name, fullName, description, url, designation, states, directionsInfo, directionsUrl, weatherInfo
    }

    /// Park identification string
    public let id: String
    /// A variable width character code used to identify a specific park
    public let parkCode: String
    /// Short park name (no designation)
    public let name: String
    /// Full park name (with designation)
    public let fullName: String?
    /// Introductory paragraph from the park homepage
    public let description: String?
    /// Type of designation (eg, national park, national monument, national recreation area, etc)
    public let designation: String?
    /// State(s) the park is located in
    public let states: [State]?
    /// General overview of how to get to the park
    public let directionsInfo: String?
    /// Link to page, if available, that provides additional detail on getting to the park
    public let directionsUrl: URL?
    /// General description of the weather in the park over the course of a year
    public let weatherInfo: String?
    /// Park Website
    public let url: URL?
}

extension Park {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        name = try values.decode(String.self, forKey: .name)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
        designation = try values.decodeIfPresent(String.self, forKey: .designation)
        directionsInfo = try values.decodeIfPresent(String.self, forKey: .directionsInfo)
        directionsUrl = try values.decodeIfPresent(String.self, forKey: .directionsUrl)?.toURL()
        weatherInfo = try values.decodeIfPresent(String.self, forKey: .weatherInfo)
        states = try values.decode(String.self, forKey: .states).toStates()
    }
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }
}

struct Parks: Decodable {
    let total: String
    let data: [Park]
}
