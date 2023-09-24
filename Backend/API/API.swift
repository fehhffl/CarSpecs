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
            if stringAfterBaseUrl.numberOfOccurrencesOf(string: "?") > 1 {
                sendResponse(for: request, statusCode: 400, error: APIError.malformedQueryParams, completionHandler)
                return
            }
            let componentAfterBaseUrl = stringAfterBaseUrl.split(separator: "?")
            endpoint = String(componentAfterBaseUrl[0])
            queryParams = createQueryParametersDict(using: String(componentAfterBaseUrl[1]))
        } else {
            endpoint = stringAfterBaseUrl
        }

        switch endpoint {
        case "carList":
            var carSummaries: [[String: Any]] = []
            let (page, limit) = getPageAndLimit(from: queryParams)

            // Page is mandatory, limit defaults to 10
            guard let page = page else {
                sendResponse(for: request, statusCode: 400, error: APIError.missingPageNumber, completionHandler)
                return
            }

            if let category = queryParams["category"] {
                carSummaries = dataBase.getCarsInCategory(category: category, page: page, limit: limit)
            } else {
                carSummaries = dataBase.getCarsSummaries(page: page, limit: limit)
            }

            sendResponse(for: request, rootKey: "cars", content: carSummaries, completionHandler)

        case "details":
            break

        case "search":
            break

        case "categories":
            let allCategories = dataBase.getAllCategories()
            sendResponse(for: request, rootKey: "categories", content: allCategories, completionHandler)
        default:
            sendResponse(for: request, statusCode: 400, error: APIError.invalidEndpoint, completionHandler)
        }
    }

    func sendResponse(
        for request: URLRequest,
        rootKey: String,
        content: [Any],
        _ completionHandler: (Data?, URLResponse?, Error?) -> Void
    ) {
        do {
            let responseData: Data = try [rootKey: content].toData()
            sendResponse(for: request, statusCode: 200, data: responseData, completionHandler)
            return
        } catch {
            sendResponse(for: request, statusCode: 500, error: error, completionHandler)
            return
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

    private func getPageAndLimit(from queryParams: [String: String]) -> (Int?, Int) {
        guard let page = Int(queryParams["page"] ?? "") else {
            return (nil, 0)
        }
        if let limit = Int(queryParams["limit"] ?? "") {
            return (page, limit)
        }
        return (page, Constants.defaultCarsPerPage)
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

extension String {
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}
