import Foundation
import Combine

private enum DataServiceEndpoint: String {
    case parks = "/parks"
    case alerts = "/alerts"
    case newsRelease = "/newsreleases"
    case visitorCenters = "/visitorcenters"
    case assets = "/places"
}

/// Main API class to interact with the National Park Service API
public class DataService {

    /// Required API key which can be requested for free from NPS Developer website
    public let apiKey: String

    private let urlFactory: RequestUrlFactory = RequestUrlFactory()

    private var errorTransformer: (Error) -> DataServiceError = { error in
        switch error {
        case DataServiceError.invalidApiKey:
            return DataServiceError.invalidApiKey
        default:
            return DataServiceError.cannotDecodeContent(error: error)
        }
    }

    private var responseTransformer: (Data, URLResponse) throws -> Data = { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataServiceError.invalidApiKey
        }
        return data
    }

    /// Initializer
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: public functions

    /**
     fetch single park information from the National Park Service Data API

     - Parameter parkCode: The National Park Service uses four letter codes - Alpha Codes - to abbreviate the names of its parks. If a park has one name in its title, like Yosemite National Park, the code word would be the first four letters of the name - YOSE. If the park has two names or more in its title, like Grand Canyon National Park, the code word would be the first two letters of each name - GRCA.

     - Returns: a respective publisher which outputs an array of parks
     */
    public func fetchPark(_ parkCode: String) -> AnyPublisher<Park?, DataServiceError> {
        return self.fetchParks(by: [parkCode], in: nil, nil)
            .map { $0.data.first }
            .eraseToAnyPublisher()
    }

    /**
     fetch park information from the National Park Service Data API

     - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
     - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
     - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
     - Returns: a respective publisher which outputs a tuple containing an array of parks as well as the total count of matching items on the server
     */
    public func fetchParks(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableParkField>? = nil) -> AnyPublisher<(data: [Park], total: Int), DataServiceError> {

        guard let validUrl = self.url(.parks, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: DataServiceError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: Parks.self, decoder: JSONDecoder())
            .map { ($0.data, Int($0.total) ?? 0) }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch alert release information from the National Park Service Data API

     - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
     - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
     - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
     - Returns: a respective publisher which outputs a tuple containing an array of alerts as well as the total count of matching items on the server
     */
    public func fetchAlerts(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableAlertField>? = nil) -> AnyPublisher<(data: [Alert], total: Int), DataServiceError> {

        guard let validUrl = self.url(.alerts, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: DataServiceError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: Alerts.self, decoder: JSONDecoder())
            .map { ($0.data, Int($0.total) ?? 0) }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch news release information from the National Park Service Data API

     - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
     - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
     - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
     - Returns: a respective publisher which outputs a tuple containing an array of news releases as well as the total count of matching items on the server
     */
    public func fetchNewsReleases(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableNewsReleaseField>? = nil) -> AnyPublisher<(data: [NewsRelease], total: Int), DataServiceError> {

        guard let validUrl = self.url(.newsRelease, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: DataServiceError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: NewsReleases.self, decoder: JSONDecoder())
            .map { ($0.data, Int($0.total) ?? 0) }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch visitor center information from the National Park Service Data API

     - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
     - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
     - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
     - Returns: a respective publisher which outputs a tuple containing an array of visitor centers as well as the total count of matching items on the server
     */
    public func fetchVisitorCenters(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableVisitorCenterField>? = nil) -> AnyPublisher<(data: [VisitorCenter], total: Int), DataServiceError> {

        guard let validUrl = self.url(.visitorCenters, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: DataServiceError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: VisitorCenters.self, decoder: JSONDecoder())
            .map { ($0.data, Int($0.total) ?? 0) }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch asset (place) information from the National Park Service Data API

     - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
     - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
     - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
     - Returns: a respective publisher which outputs a tuple containing an array of assets as well as the total count of matching items on the server
     */
    public func fetchAssets(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableAssetField>? = nil) -> AnyPublisher<(data: [Asset], total: Int), DataServiceError> {

        guard let validUrl = self.url(.assets, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: DataServiceError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: Assets.self, decoder: JSONDecoder())
            .map { ($0.data, Int($0.total) ?? 0) }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    // MARK: private functions
    private func url<T: RequestableField>(_ endpoint: DataServiceEndpoint, by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<T>?) -> URL? {

        var urlComponents = self.urlFactory.apiUrlComponents(for: endpoint.rawValue, authorizedBy: self.apiKey)

        let parkCodeQueryParameterValue = parkCodes?.joined(separator: ",")
        if parkCodeQueryParameterValue != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "parkCode", value: parkCodeQueryParameterValue))
        }

        let statesQueryParameterValue = states?.map { $0.rawValue }.joined(separator: ",")
        if statesQueryParameterValue != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "stateCode", value: statesQueryParameterValue))
        }

        self.urlFactory.add(requestOptions, to: &urlComponents)

        return urlComponents.url
    }
}
