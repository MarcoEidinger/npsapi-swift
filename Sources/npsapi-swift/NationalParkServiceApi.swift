import Foundation
import Combine

private enum NationalParkServiceApiEndpoint: String {
    case parks = "/parks"
    case alerts = "/alerts"
    case newsRelease = "/newsreleases"
    case visitorCenters = "/visitorcenters"
}

/// Main API class to interact with the National Park Service API
public class NationalParkServiceApi {

    /// Required API key which can be requested for free from NPS Developer website
    public let apiKey: String

    private let urlFactory: RequestUrlFactory = RequestUrlFactory()

    private var errorTransformer: (Error) -> NationalParkServiceApiError = { error in
        switch error {
        case NationalParkServiceApiError.invalidApiKey:
            return NationalParkServiceApiError.invalidApiKey
        default:
            return NationalParkServiceApiError.cannotDecodeContent(error: error)
        }
    }

    private var responseTransformer: (Data, URLResponse) throws -> Data = { data, response -> Data in
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NationalParkServiceApiError.invalidApiKey
        }
        return data
    }

    /// Initializer
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: public functions

    /**
        fetch park information from the National Park Service Data API

        - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
        - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
        - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
        - Returns: a respective publisher
    */
    public func fetchParks(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableParkField>? = nil) -> AnyPublisher<[Park], NationalParkServiceApiError> {

        guard let validUrl = self.url(.parks, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: Parks.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
        fetch alert release information from the National Park Service Data API

        - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
        - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
        - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
        - Returns: a respective publisher
    */
    public func fetchAlerts(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableAlertField>? = nil) -> AnyPublisher<[Alert], NationalParkServiceApiError> {

        guard let validUrl = self.url(.alerts, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: Alerts.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
        fetch news release information from the National Park Service Data API

        - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
        - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
        - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
        - Returns: a respective publisher
    */
    public func fetchNewsReleases(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableNewsReleaseField>? = nil) -> AnyPublisher<[NewsRelease], NationalParkServiceApiError> {

        guard let validUrl = self.url(.newsRelease, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: NewsReleases.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
        fetch visitor center information from the National Park Service Data API

        - Parameter parkCodes: to limit results for certain parks only. Array of park codes, e.g. ["yell"]. Can be nil or empty
        - Parameter states: to limit results for certain states only. Array of US states, e.g [.california]. Can be nil or empty
        - Parameter requestOptions: to specify result amount (default: 50) and further influence search critierias
        - Returns: a respective publisher
    */
    public func fetchVisitorCenters(by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<RequestableVisitorCenterField>? = nil) -> AnyPublisher<[VisitorCenter], NationalParkServiceApiError> {

        guard let validUrl = self.url(.visitorCenters, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.badURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap(responseTransformer)
            .decode(type: VisitorCenters.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    // MARK: private functions
    private func url<T: RequestableField>(_ endpoint: NationalParkServiceApiEndpoint, by parkCodes: [String]? = [], in states: [StateInUSA]? = [], _ requestOptions: RequestOptions<T>?) -> URL? {

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
