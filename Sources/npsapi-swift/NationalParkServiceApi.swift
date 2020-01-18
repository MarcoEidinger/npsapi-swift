import Foundation
import Combine

enum NationalParkServiceApiError: Error {
    case invalidUrl
}

@available(iOS 13.0, *)
class NationalParkServiceApi {

    private let apiKey: String
    private let baseUrlRemoteApi: String = "https://developer.nps.gov/api/v1/"
    private let queryParameterApiKey: String = "api_key"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchParks(by parkCodes: [String]? = []) -> AnyPublisher<[Park], Error> {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "developer.nps.gov/api/v1"
        urlComponents.path = "/parks"
        urlComponents.queryItems = [
           URLQueryItem(name: queryParameterApiKey, value: apiKey)
        ]

        let parkCodeQueryParameterValue = parkCodes?.joined(separator: ",")
        if parkCodeQueryParameterValue != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "parkCode", value: parkCodeQueryParameterValue))
        }

        let urlString = urlComponents.url!.absoluteString.removingPercentEncoding!
        let url = URL(string: urlString)!

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (result) -> [Park] in
                let jsonString = String(data: result.data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
                let parks = try JSONDecoder().decode(Parks.self, from: jsonData!)
                return parks.data
            })
            .eraseToAnyPublisher()
    }
}
