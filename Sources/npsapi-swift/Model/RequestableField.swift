//
//  RequestableField.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/18/20.
//

import Foundation

/// Field which can explicitly be requested for an entity, e.g Park
public protocol RequestableField: RawRepresentable {
    /// Name of the field
    var fieldName: String { get }
}

public extension RequestableField {
    var fieldName: String {
        return String(describing: self.rawValue)
    }
}
