//
//  Internal.swift
//  NatParkSwiftKit
//
//  Created by Eidinger, Marco on 1/21/20.
//

import Foundation
import CoreLocation

enum DataServiceEndpoint: String {
    case parks = "/parks"
    case alerts = "/alerts"
    case newsRelease = "/newsreleases"
    case visitorCenters = "/visitorcenters"
    case assets = "/places"
}

protocol IResource: Decodable {
    associatedtype NatParkServiceEntity
    var total: String { get }
    var data: [NatParkServiceEntity] { get }
}

struct Resources<NatParkServiceEntity: Decodable>: IResource {
    let total: String
    let data: [NatParkServiceEntity]
}

extension String {
    func toURL() -> URL? {
        return URL(string: self)
    }

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

    func toLocation() -> CLLocation? {
        guard let lat = self.toLatitude(),
            let long = self.toLongitude() else {
                return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }

    func toLatitude() -> Double? {
        guard let latitudeSeparator = self.firstIndex(of: ":") else {
            return nil
        }
        let startLat = self.index(latitudeSeparator, offsetBy: +1)
        guard let endLat = self.firstIndex(of: ",") else {
            return nil
        }
        return Double(String(self[startLat..<endLat]))
    }

    func toLongitude() -> Double? {
        guard let longitudeSeparator = self.firstIndex(of: ",") else {
            return nil
        }
        // default format "lat:44.59824417, long:-110.5471695"
        var endLong = self.endIndex
        var distance = +7
        // fallback format "{lat:63.7308262, lng:-148.9171829}"
        if self.contains("lng") {
            distance = +6
            endLong = self.index(self.endIndex, offsetBy: -1)
        }
        let startLong = self.index(longitudeSeparator, offsetBy: distance)
        return Double(String(self[startLong..<endLong]))
    }

    func toStates() -> [StateInUSA] {
        var states: [StateInUSA] = []
        let statesAsStringArray = self.components(separatedBy: ",")
        statesAsStringArray.forEach { (potentialState) in
            guard let state = StateInUSA(rawValue: potentialState) else {
                return
            }
            states.append(state)
        }
        return states
    }
}
