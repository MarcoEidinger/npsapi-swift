//
//  File.swift
//  
//
//  Created by Eidinger, Marco on 1/16/20.
//

import Foundation

struct Park: Decodable {
    enum CodingKeys: CodingKey {
      case id, parkCode, name, fullName, description, url, designation, states
    }

    let id: String
    let parkCode: String
    let name: String
    let fullName: String
    let description: String
    let states: [States]
}

extension String {
    func toStates() -> [States] {
        var states: [States] = []
        let statesAsStringArray = self.components(separatedBy: ",")
        statesAsStringArray.forEach { (potentialState) in
            guard let state = States(rawValue: potentialState) else {
                return
            }
            states.append(state)
        }
        return states
    }
}

extension Park {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        parkCode = try values.decode(String.self, forKey: .parkCode)
        name = try values.decode(String.self, forKey: .name)
        fullName = try values.decode(String.self, forKey: .fullName)
        description = try values.decode(String.self, forKey: .description)

        let statesAsString = try values.decode(String.self, forKey: .states)
        states = statesAsString.toStates()
    }
}

struct Parks: Decodable {
    let total: String
    let data: [Park]
}
