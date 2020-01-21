//
//  Alert.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/18/20.
//

import Foundation

/// Requestable attribute of Park model
public enum RequestableAlertField: String, RequestableField {

    /// Unique identifier for an alert record
    case id
    /// A variable width character code used to identify a specific park
    case parkCode
    /// Alert title
    case title
    /// Alert description
    case description
    /// Alert type: danger, caution, information, or park closure
    case category
    /// Link to more information about the alert, if available
    case url
}

/// Alerts communicate information about hazardous, potentially hazardous, or changing conditions that may affect a visit to a national park. Alert data includes the type of alert, title, description, and optional link to additional information.
public struct Alert: Decodable {
    enum CodingKeys: CodingKey {
      case id, parkCode, title, description, category, url
    }

    /// Unique identifier for an alert record
    public let id: String
    /// A variable width character code used to identify a specific park
    public let parkCode: String
    /// Alert title
    public let title: String
    /// Alert description
    public let description: String
    /// Alert type: danger, caution, information, or park closure
    public let category: String
    /// Link to more information about the alert, if available
    public let url: URL?
}

extension Alert {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        title = try values.decode(String.self, forKey: .title)
        description = try values.decode(String.self, forKey: .description)
        category = try values.decode(String.self, forKey: .category)
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
    }
}

struct Alerts: Decodable {
    let total: String
    let data: [Alert]
}
