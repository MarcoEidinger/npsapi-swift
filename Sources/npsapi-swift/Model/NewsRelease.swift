//
//  NewsRelease.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/21/20.
//

import Foundation

/// Requestable attribute of NewsRelease model
public enum RequestableNewsReleaseField: String, RequestableField {
    /// Unique identifier for the news release
    case id
    /// A variable width character code used to identify a specific park
    case parkCode
    /// News release title
    case title
    /// Short description of news release content
    case abstract
    /// Date news release was released
    case releaseDate = "releasedate"
    /// Link to full news release
    case url
    /// News release image
    case image
}

/// News release data includes a title, abstract, and link to national park news releases, as well as an optional image.
public struct NewsRelease: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, parkCode, title, releaseDate = "releasedate", abstract, url, image
    }

    /// Unique identifier for the news release
    public let id: String
    /// A variable width character code used to identify a specific park
    public let parkCode: String
    /// News release title
    public let title: String
    /// Short description of news release content
    public let abstract: String?
    /// Date news release was released
    public let releaseDate: Date?
    /// Link to full news release
    public let url: URL?
    /// News release image
    public let image: NpsImage?
}

extension NewsRelease {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        title = try values.decode(String.self, forKey: .title)
        abstract = try values.decodeIfPresent(String.self, forKey: .abstract)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)?.toDate()
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
        image = try values.decodeIfPresent(NpsImage.self, forKey: .image)
    }
}

extension String {
    func toDate() -> Date? {
        var releaseDateAsString = self
        releaseDateAsString = String(releaseDateAsString.dropLast())
        releaseDateAsString = String(releaseDateAsString.dropLast())
        let releaseDateString: String = releaseDateAsString
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-mm-dd HH:mm:ss"
        dateFor.locale = Locale(identifier: "en_US_POSIX")
        return dateFor.date(from: releaseDateString)
    }
}

struct NewsReleases: Decodable {
    let total: String
    let data: [NewsRelease]
}
