//
//  Asset.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/24/20.
//

import Foundation

/// Requestable attribute of Asset model
public enum RequestableAssetField: String, RequestableField {
    case void
}

/// Places are shared content assets that are tagged so they can appear in a variety of places on NPS.gov. Data includes a title, image, short description of the content, and link to more information about the asset.
public struct Asset: Decodable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case id, listingDescription = "listingdescription", listingImage = "listingimage", title, url
    }

    /// Uniquely identifies place record
    public let id: String
    /// Short description of the content
    public let listingDescription: String
    /// mall image that accompanies the short description
    public let listingImage: NpsImage
    /// Asset title
    public let title: String
    /// Link to more information about the asset, if available
    public let url: URL?
}

extension Asset {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        listingDescription = try values.decode(String.self, forKey: .listingDescription)
        listingImage = try values.decode(NpsImage.self, forKey: .listingImage)
        title = try values.decode(String.self, forKey: .title)
        url = try values.decodeIfPresent(String.self, forKey: .url)?.toURL()
    }
}
