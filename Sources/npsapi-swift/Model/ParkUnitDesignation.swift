//
//  UnitDesignation.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/23/20.
//

import Foundation

/// Designation of a unit belonging to the National Park Service
public enum ParkUnitDesignation: String {
    /// National Park
    case nationalPark = "National Park"
    /// National Monument
    case nationalMonument = "National Monument"
    /// National Memorial
    case nationalMemorial = "National Memorial"
    /// National Historic Trail
    case nationalHistoricTrail = "National Historic Trail"
    /// National Historic Site
    case nationalHistoricSite = "National Historic Site"
    /// National Historical Park
    case nationalHistoricalPark = "National Historical Park"
    /// National Recreation Area
    case nationalRecreationArea = "National Recreation Area"
    /// National Preserve
    case nationalPreserve = "National Preserve"
    /// National Seashore
    case nationalSeashore = "National Seashore"
    /// National and State Parks
    case nationalAndStateParks = "National and State Parks"
    /// National Battlefield
    case nationalBattlefield = "National Battlefield"
    /// National Lakeshore
    case nationalLakeshore = "National Lakeshore"
    /// National Scenic Trail
    case nationalScenicTrail = "National Scenic Trail"
    /// National Heritage Area
    case nationalHeritageArea = "National Heritage Area"
    /// National Military Park
    case nationalMilitaryPark = "National Military Park"
    /// National Historical Reserve
    case nationalHistoricalReserve = "National Historical Reserve"
    /// National Heritage Corridor
    case nationalHeritageCorridor = "National Heritage Corridor"
    /// National Park & Preserve
    case nationalParkAndPreserve = "National Park & Preserve"
    /// National Geologic Trail
    case nationalGeologicTrail = "National Geologic Trail"
    /// National River
    case nationalRiver = "National River"
    /// National Wild and Scenic River
    case nationalWildAndScenicRiver = "National Wild and Scenic River"
    /// National Scenic River
    case nationalScenicRiver = "National Scenic River"
    /// National Scenic Riverway
    case nationalScenicRiverway = "National Scenic Riverway"
    /// National Scenic Riverways
    case nationalScenicRiverways = "National Scenic Riverways"
    /// National Recreational River
    case nationalRecreationalRiver = "National Recreational River"
    /// National Historical Park and Preserve
    case nationalHistoricalParkAndPreserve = "National Historical Park and Preserve"
    /// National Monument & Preserve
    case nationalMonumentAndPreserve = "National Monument & Preserve"
    /// National Historical Park and Ecological Preserve
    case nationalHistoricalParkAndEcologicalPreserve = "National Historical Park and Ecological Preserve"
    /// National Reserve
    case nationalReserve = "National Reserve"

    /// Heritage Area
    case heritageArea = "Heritage Area"
    /// Park
    case park = "Park"
    /// Parkway
    case parkway = "Parkway"
    /// Memorial
    case memorial = "Memorial"
    /// Memorial Parkway
    case memorialParkway = "Memorial Parkway"
    /// Cultural Heritage Corridor
    case culturalHeritageCorridor = "Cultural Heritage Corridor"
    /// Part of Colonial National Historical Park
    case partOfColonialNationalHistoricalPark = "Part of Colonial National Historical Park"
    /// Part of Statue of Liberty National Monument
    case partOfStatueOLibertyNationalMonument = "Part of Statue of Liberty National Monument"

    /// Scenic & Recreational River
    case scenicAndRecreationalRiver = "Scenic & Recreational River"
    /// Wild & Scenic River
    case wildAndScenicRiver = "Wild & Scenic River"
    /// Wild River
    case wildRiver = "Wild River"

    /// International Park
    case internationalPark = "International Park"
    /// International Historic Site
    case internationalHistoricSite = "International Historic Site"
    /// National Parks
    case nationalParks = "National Parks"
    /// Ecological & Historic Preserve
    case ecologicalAndHistoricPreserve = "Ecological & Historic Preserve"

    /// Unknown; either record does not have designation or designation is incorrectly spelled
    case unknown = ""

    /// Preferred initializer; cannot return null; will map to .unknown if necessary
    public init(validDesignationOrUnknown: String?) {
        guard let input = validDesignationOrUnknown else {
            self = ParkUnitDesignation.unknown
            return
        }
        self = ParkUnitDesignation(rawValue: input) ?? ParkUnitDesignation.unknown
    }
}
