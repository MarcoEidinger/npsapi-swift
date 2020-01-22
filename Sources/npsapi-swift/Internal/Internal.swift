//
//  Internal.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/21/20.
//

import Foundation
import CoreLocation

struct Parks: Decodable {
    let total: String
    let data: [Park]
}

struct Alerts: Decodable {
    let total: String
    let data: [Alert]
}

struct NewsReleases: Decodable {
    let total: String
    let data: [NewsRelease]
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
        guard let lat = self.toLantitude(),
            let long = self.toLongtitude() else {
                return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }

    func toLantitude() -> Double? {
        guard let meep = self.firstIndex(of: ":") else {
            return nil
        }
        let startLat = self.index(meep, offsetBy: +1)
        guard let endLat = self.firstIndex(of: ",") else {
            return nil
        }
        return Double(String(self[startLat..<endLat]))
    }

    func toLongtitude() -> Double? {
        guard let doo = self.firstIndex(of: ",") else {
            return nil
        }
        let startLong = self.index(doo, offsetBy: +7)
        let endLong = self.endIndex
        return Double(String(self[startLong..<endLong]))
    }

    func toStates() -> [State] {
        var states: [State] = []
        let statesAsStringArray = self.components(separatedBy: ",")
        statesAsStringArray.forEach { (potentialState) in
            guard let state = State(rawValue: potentialState) else {
                return
            }
            states.append(state)
        }
        return states
    }
}
