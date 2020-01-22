//
//  NationalParkServiceApiError.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/18/20.
//

import Foundation

/// Errors either related to the client or server side implementation of the National Park Service Api
public enum NationalParkServiceApiError: Error {
    /// Invalid API Key (HTTP 403 - Forbidden)
    case invalidApiKey
    /// A malformed URL prevented a URL request from being initiated (Client API issue)
    case badURL
    /// Invalid Server Response
    case cannotDecodeContent(error: Error)
}
