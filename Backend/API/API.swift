//
//  API.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

public class API {
    public static var shared = API()
    private lazy var dataBase = Database.shared

    private enum Constants {
        static let defaultCarsPerPage: Int = 10
    }

    public func get(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void) {
        guard let url = request.url else {
            sendResponse(for: request, statusCode: 400, error: APIError.missingURL, completionHandler)
            return
        }

        let (baseUrl, stringAfterBaseUrl) = url.getURLComponents()

        guard let baseUrl, !baseUrl.isEmpty else {
            sendResponse(for: request, statusCode: 400, error: APIError.malformedURL, completionHandler)
            return
        }

        let urlWithoutBaseUrl = url.absoluteString.replacingOccurrences(of: baseUrl, with: "")

        guard !urlWithoutBaseUrl.isEmpty else {
            sendResponse(for: request, statusCode: 400, error: APIError.missingEndpoint, completionHandler)
            return
        }

        var endpoint: String = ""
        var queryParams: [String: String] = [:]

        if stringAfterBaseUrl.contains("?") {
            let componentAfterBaseUrl = stringAfterBaseUrl.split(separator: "?")
            endpoint = String(componentAfterBaseUrl[0])
            queryParams = createQueryParametersDict(using: String(componentAfterBaseUrl[1]))
        } else {
            endpoint = stringAfterBaseUrl
        }

        switch endpoint {
        case "carList":
            var carPreviews: [[String: Any]] = [[:]]
            if queryParams.isEmpty {
                carPreviews = dataBase.getCarsPreviews(page: 1, limit: Constants.defaultCarsPerPage)
            } else if let page = Int(queryParams["page"] ?? ""),
                      let limit = Int(queryParams["limit"] ?? String(Constants.defaultCarsPerPage)) {
                carPreviews = dataBase.getCarsPreviews(page: page, limit: limit)
            } else {
                sendResponse(for: request, statusCode: 400, error: APIError.missingPageNumber, completionHandler)
                return
            }
            do {
                let responseData: Data = try ["cars": carPreviews].toData()
                sendResponse(for: request, statusCode: 200, data: responseData, completionHandler)
                return
            } catch {
                sendResponse(for: request, statusCode: 500, error: error, completionHandler)
                return
            }

        case "details":
            break
        case "search":
            break
        case "categories":
            break
        default:
            sendResponse(for: request, statusCode: 400, error: APIError.invalidEndpoint, completionHandler)
        }
    }

    func sendResponse(
        for request: URLRequest,
        statusCode: Int,
        data: Data? = nil,
        error: Error? = nil,
        _ completionHandler: (Data?, URLResponse?, Error?) -> Void
    ) {
        completionHandler(
            data,
            HTTPURLResponse(
                url: request.url ?? URL(string: "")!,
                statusCode: statusCode,
                httpVersion: "HTTP/1.1",
                headerFields: request.allHTTPHeaderFields),
            error
        )
    }

    func createQueryParametersDict(using queryParametersString: String) -> [String: String] {
        let queryParameters = queryParametersString.split(separator: "&")
        guard !queryParameters.isEmpty else {
            return [:]
        }
        var queryParametersDict: [String: String] = [:]
        queryParameters.forEach { queryParameter in
            if queryParameter.contains("=") {
                let keyOrValue = queryParameter.split(separator: "=")
                let key = String(keyOrValue[0])
                let value = String(keyOrValue[1])
                queryParametersDict[key] = value
            }
        }
        return queryParametersDict
    }
}

extension URL {
    func getURLComponents() -> (String?, String) {
        let urlString = self.absoluteString
        if urlString.contains("://") {
            var components = urlString.components(separatedBy: "://")
            let internetProtocol = components[0] + "://"
            let urlWithoutProtocol = components[1]

            if urlWithoutProtocol.contains("/") {
                components = urlWithoutProtocol.components(separatedBy: "/")
                let baseURL = internetProtocol + components[0] + "/"
                let stringAfterBaseUrl = urlString.replacingOccurrences(of: baseURL, with: "")
                return (baseURL, stringAfterBaseUrl)
            }
        }
        return (nil, "")
    }
}
