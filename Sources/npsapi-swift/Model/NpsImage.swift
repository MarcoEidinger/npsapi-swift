//
//  NpsImage.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/21/20.
//

import Foundation

/// Image information provided by National Park Service
public struct NpsImage: Decodable {
    enum CodingKeys: String, CodingKey {
        case title, description, caption, altText, credit, url
    }

    /// Image Title
    public let title: String?
    /// Image Title
    public let description: String?
    /// Image Caption
    public let caption: String?
    /// Alternative Text for Image
    public let altText: String?
    /// Credit to acknowledge contributor / creator of Image
    public let credit: String?
    /// Link to Image
    public let url: URL?
}

extension NpsImage {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        caption = try values.decode(String.self, forKey: .caption)
        altText = try values.decodeIfPresent(String.self, forKey: .altText)
        credit = try values.decodeIfPresent(String.self, forKey: .credit)
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
    }
}
