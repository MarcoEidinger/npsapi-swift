//
//  File.swift
//
//
//  Created by Eidinger, Marco on 1/16/20.
//

import Foundation

/// Constituent political entity in the United States
public enum State: String, CustomDebugStringConvertible {
    /// Alabama
    case alabama = "AL"
    /// Alaska
    case alaska = "AK"
    /// Arizona
    case arizona = "AZ"
    /// Arkansas
    case arkansas = "AR"
    /// California
    case californa = "CA"
    /// Colorado
    case colorado = "CO"
    /// Connecticut
    case connecticut = "CT"
    /// Delaware
    case delaware = "DE"
    /// Florida
    case florida = "FL"
    /// Georgia
    case georgia = "GA"
    /// Hawaii
    case hawaii = "HI"
    /// Idaho
    case idaho = "ID"
    /// Illinois
    case illinois = "IL"
    /// Indiana
    case indiana = "IN"
    /// Iowa
    case iowa = "IA"
    /// Kansas
    case kansas = "KS"
    /// Kentucky
    case kentucky = "KY"
    /// Louisiana
    case louisiana = "LA"
    /// Maine
    case maine = "ME"
    /// Maryland
    case maryland = "MD"
    /// Massachusetts
    case massachusetts = "MA"
    /// Michigan
    case michigan = "MI"
    /// Minnesota
    case minnesota = "MN"
    /// Mississippi
    case mississippi = "MS"
    /// Missouri
    case missouri = "MO"
    /// Montana
    case montana = "MT"
    /// Nebraska
    case nebraska = "NE"
    /// Nevada
    case nevada = "NV"
    /// New Hampshire
    case newhampshire = "NH"
    /// New Jersey
    case newjersey = "NJ"
    /// New Mexcio
    case newmexico = "NM"
    /// New York
    case newyork = "NY"

    /// Returns 2 character state code, e.g. CA for california
    public var debugDescription: String {
        return self.rawValue
    }
}
