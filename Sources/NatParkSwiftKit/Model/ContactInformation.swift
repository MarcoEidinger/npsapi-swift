//
//  ContactInformation.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 2/10/20.
//

import Foundation

/// Information about contacting staff at the facility
public struct ContactInformation: Decodable {
    /// List of Contacts available via phone
    public let phoneNumbers: [PhoneNumberInfo]?
    /// List of Contacts available via email
    public let emailAddresses: [EmailAddressInfo]?
}

/// Contact available via phone
public struct PhoneNumberInfo: Decodable {
    enum CodingKeys: String, CodingKey {
        case phoneNumber, description, ext = "extension", type
    }
    /// Numeric phone number
    public let phoneNumber: String
    /// Contact description
    public let description: String
    /// Extension of phone number
    public let ext: String
    /// Phone number type
    public let type: PhoneNumberType
}

/// Contact available via email
public struct EmailAddressInfo: Decodable {
    /// Email address
    public let emailAddress: String
    /// Contact description
    public let description: String
}

/// Phone number type
public enum PhoneNumberType: String, Decodable {
    /// Voice
    case voice = "Voice"
    /// Fax
    case fax = "Fax"
    /// Teletypewriter
    case tty = "TTY"
}
