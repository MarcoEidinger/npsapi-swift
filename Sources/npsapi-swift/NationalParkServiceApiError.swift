//
//  NationalParkServiceApiError.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/18/20.
//

import Foundation

/// Errors either related to the client or server side implementation of the National Park Service Api
public enum NationalParkServiceApiError: Error {
    /// Invalid Input
    case invalidInput
    /// Invalid Server Response
    case invalidServerResponse
}
