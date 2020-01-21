import Foundation
import Combine

/// Main API class to interact with the National Park Service API
public class NationalParkServiceApi {

    /// Required API key which can be requested for free from NPS Developer website
    public let apiKey: String

    private let urlFactory: RequestUrlFactory = RequestUrlFactory()

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    /**
        fetch park information

    */
    public func fetchParks(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableParkField>? = nil) -> AnyPublisher<[Park], NationalParkServiceApiError> {

        guard let validUrl = self.parksUrl(by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.invalidInput).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap({ (result) -> [Park] in
                let parks = try JSONDecoder().decode(Parks.self, from: self.jsonData(from: result))
                return parks.data
            })
            .mapError { _ in
                // if it's our kind of error already, we can return it directly
                return NationalParkServiceApiError.invalidServerResponse
            }
            .eraseToAnyPublisher()
    }

    private func parksUrl(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableParkField>?) -> URL? {

        var urlComponents = self.urlFactory.apiUrlComponents(for: "/parks", authorizedBy: self.apiKey)

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

    /**
        fetch alert information

    */
    public func fetchAlerts(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableAlertField>? = nil) -> AnyPublisher<[Alert], NationalParkServiceApiError> {

        guard let validUrl = self.alertsUrl(by: parkCodes, in: states, requestOptions) else {
            return Fail(error: NationalParkServiceApiError.invalidInput).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: validUrl)
            .tryMap({ (result) -> [Alert] in
                let parks = try JSONDecoder().decode(Alerts.self, from: self.jsonData(from: result))
                return parks.data
            })
            .mapError { _ in
                // if it's our kind of error already, we can return it directly
                return NationalParkServiceApiError.invalidServerResponse
            }
            .eraseToAnyPublisher()
    }

    private func jsonData(from result: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let jsonString = String(data: result.data, encoding: .utf8) else {
            throw NationalParkServiceApiError.invalidServerResponse
        }
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw NationalParkServiceApiError.invalidServerResponse
        }
        return jsonData
    }

    private func alertsUrl(by parkCodes: [String]? = [], in states: [State]? = [], _ requestOptions: RequestOptions<RequestableAlertField>?) -> URL? {

        var urlComponents = self.urlFactory.apiUrlComponents(for: "/alerts", authorizedBy: self.apiKey)

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
