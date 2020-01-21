import Foundation
import Combine

private enum NationalParkServiceApiEndpoint: String {
    case parks = "/parks"
    case alerts = "/alerts"
    case newsRelease = "/newsreleases"
}

/// Main API class to interact with the National Park Service API
public class NationalParkServiceApi {

    /// Required API key which can be requested for free from NPS Developer website
    public let apiKey: String

    private let urlFactory: RequestUrlFactory = RequestUrlFactory()

    private var errorTransformer: (Error) -> NationalParkServiceApiError = { _ in NationalParkServiceApiError.invalidServerResponse }

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: public functions

    /**
     fetch park information

     */
    public func fetchParks(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableParkField>? = nil) -> AnyPublisher<[Park], NationalParkServiceApiError> {

        guard let validUrl = self.url(.parks, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.invalidInput).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .map { $0.data }
            .decode(type: Parks.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch alert information

     */
    public func fetchAlerts(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableAlertField>? = nil) -> AnyPublisher<[Alert], NationalParkServiceApiError> {

        guard let validUrl = self.url(.alerts, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.invalidInput).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .map { $0.data }
            .decode(type: Alerts.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    /**
     fetch news release information

     */
    public func fetchNewsReleases(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableNewsReleaseField>? = nil) -> AnyPublisher<[NewsRelease], NationalParkServiceApiError> {

        guard let validUrl = self.url(.newsRelease, by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.invalidInput).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .map { $0.data }
            .decode(type: NewsReleases.self, decoder: JSONDecoder())
            .map { $0.data }
            .mapError(self.errorTransformer)
            .eraseToAnyPublisher()
    }

    // MARK: private functions
    private func url<T: RequestableField>(_ endpoint: NationalParkServiceApiEndpoint, by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<T>?) -> URL? {

        var urlComponents = self.urlFactory.apiUrlComponents(for: endpoint.rawValue, authorizedBy: self.apiKey)

        let parkCodeQueryParameterValue = parkCodes?.joined(separator: ",")
        if parkCodeQueryParameterValue != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "parkCode", value: parkCodeQueryParameterValue))
        }

        let statesQueryParameterValue = states?.map { $0.debugDescription }.joined(separator: ",")
        if statesQueryParameterValue != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: "stateCode", value: statesQueryParameterValue))
        }

        self.urlFactory.add(requestOptions, to: &urlComponents)

        return urlComponents.url
    }
}
