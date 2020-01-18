//
//  RequestUrlFactory.swift
//  npsapi-swift
//
//  Created by Eidinger, Marco on 1/18/20.
//

import Foundation

class RequestUrlFactory {

    func apiUrlComponents(for endpoint: String, authorizedBy apiKey: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "developer.nps.gov"
        urlComponents.path = "/api/v1" + endpoint
        urlComponents.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey)
        ]
        return urlComponents
    }

    func add(_ requestOptions: RequestOptions<RequestableParkField>?, to urlComponents: inout URLComponents) {
        if let limit = requestOptions?.limit {
            urlComponents.queryItems?.append(URLQueryItem(name: "limit", value: String(limit)))
        }

        if let query = requestOptions?.searchQuery {
            urlComponents.queryItems?.append(URLQueryItem(name: "q", value: query))
        }

        if let fields = requestOptions?.fields {
            let fieldsQueryParameterValue = fields.map { $0.debugDescription }.joined(separator: ",")
            if fieldsQueryParameterValue.isEmpty == false {
                urlComponents.queryItems?.append(URLQueryItem(name: "fields", value: fieldsQueryParameterValue))
            }
        }
    }
}
