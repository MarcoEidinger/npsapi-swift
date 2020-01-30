//
//  File.swift
//
//
//  Created by Eidinger, Marco on 1/16/20.
//

import Foundation

/// Constituent political entity in the United States
public enum StateInUSA: String, CaseIterable {
    /// Alabama
    case alabama = "AL"
    /// Alaska
    case alaska = "AK"
    /// Arizona
    case arizona = "AZ"
    /// Arkansas
    case arkansas = "AR"
    /// California
    case california = "CA"
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
    case newHampshire = "NH"
    /// New Jersey
    case newJersey = "NJ"
    /// New Mexcio
    case newMexico = "NM"
    /// New York
    case newYork = "NY"
    /// North Carolina
    case northCarolina = "NC"
    /// North Dakota
    case northDakota = "ND"
    /// Ohio
    case ohio = "OH"
    /// Oklahoma
    case oklahoma = "OK"
    /// Oregon
    case oregon = "OR"
    //// Pennsylvania
    case pennsylvania = "PA"
    /// Rhode Island
    case rhodeIsland = "RI"
    /// South Carolina
    case southCarolina = "SC"
    //// South Dakota
    case southDakota = "SD"
    /// Tennessee
    case tennessee = "TN"
    /// Texas
    case texax = "TX"
    /// Utah
    case utah = "UT"
    /// Vermont
    case vermont = "VT"
    /// Virginia
    case virgina = "VA"
    /// Washington
    case washington = "WA"
    /// West Virginia
    case westVirginia = "WV"
    /// Wisconsin
    case wisconsin = "WI"
    /// Wyoming
    case wyoming = "WY"

    /// Returns name of the state, e.g. "California" for .california
    public var name: String {
        let caseName = String(describing: self)
        var caseNameMissingFirstCharacter: String = String(caseName.dropFirst())

        for character in caseNameMissingFirstCharacter where character.isUppercase {
            if let insertIndex = caseNameMissingFirstCharacter.firstIndex(of: character) {
                caseNameMissingFirstCharacter.insert(" ", at: insertIndex)
            }
        }

        let capitalizedCaseName = caseName.prefix(1).capitalized + caseNameMissingFirstCharacter

        return capitalizedCaseName
    }

    /// Returns 2 character state code, e.g. "CA" for .california
    public var postalAbbreviation: String {
        return self.rawValue
    }
}
