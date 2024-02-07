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
        static let defaultAPIDelay: UInt32 = 2
    }

    public func get(request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void) {
        if !NetworkMonitor.shared.isMonitoring {
            NetworkMonitor.shared.startMonitoring()
        }
        guard let url = request.url else {
            sendResponse(for: request, statusCode: 400, error: APIError.missingURL, completionHandler)
            return
        }

        let (nullableBaseUrl, stringAfterBaseUrl) = url.getURLComponents()

        guard let baseUrl = nullableBaseUrl, !baseUrl.isEmpty else {
            sendResponse(for: request, statusCode: 400, error: APIError.malformedURL, completionHandler)
            return
        }
        
        let urlString = url.absoluteString.removingPercentEncoding ?? url.absoluteString
        let urlWithoutBaseUrl = urlString.replacingOccurrences(of: baseUrl, with: "")

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

        if endpoint.starts(with: "carList") {
            var carSummaries: [[String: Any]] = []
            let (page2, limit) = getPageAndLimit(from: queryParams)

            // Page is mandatory, limit defaults to 10
            guard let page = page2 else {
                sendResponse(for: request, statusCode: 400, error: APIError.missingPageNumber, completionHandler)
                return
            }

            if let category = queryParams["category"] {
                carSummaries = dataBase.getCarsInCategory(category: category, page: page, limit: limit)
            } else {
                carSummaries = dataBase.getCarsSummaries(page: page, limit: limit)
            }

            sendResponse(for: request, rootKey: "cars", content: carSummaries, completionHandler)

        } else if endpoint.starts(with: "details") {
            let components = endpoint.split(separator: "/")
            guard components.count >= 2 else {
                sendResponse(for: request, statusCode: 400, error: APIError.missingCarId, completionHandler)
                return
            }
            guard let cardId = Int(components[1]) else {
                sendResponse(for: request, statusCode: 400, error: APIError.invalidCarId, completionHandler)
                return
            }
            guard let carDetails = dataBase.getCarDetails(id: cardId) else {
                sendResponse(for: request, statusCode: 404, error: APIError.carNotFound, completionHandler)
                return
            }

            do {
                let responseData: Data = try carDetails.toData()
                sendResponse(for: request, statusCode: 200, data: responseData, completionHandler)
            } catch {
                sendResponse(for: request, statusCode: 500, error: error, completionHandler)
                return
            }

        } else if endpoint.starts(with: "search") {
            var searchResult: [[String: Any]] = []
            let (page2, limit) = getPageAndLimit(from: queryParams)

            // Page is mandatory, limit defaults to 10
            guard let page = page2 else {
                sendResponse(for: request, statusCode: 400, error: APIError.missingPageNumber, completionHandler)
                return
            }

            if let carName = queryParams["name"], !carName.isEmpty {
                searchResult = dataBase.getCarsBy(name: carName, page: page, limit: limit)
            } else {
                searchResult = dataBase.getCarsSummaries(page: page, limit: limit)
            }

            sendResponse(for: request, rootKey: "cars", content: searchResult, completionHandler)

        } else if endpoint.starts(with: "categories") {
            let allCategories = dataBase.getAllCategories()
            sendResponse(for: request, rootKey: "categories", content: allCategories, completionHandler)
        } else {
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
        delayInSeconds: UInt32 = Constants.defaultAPIDelay,
        _ completionHandler: (Data?, URLResponse?, Error?) -> Void
    ) {
        // Simulate network response time
        sleep(delayInSeconds)
        // Only send response if network is available
        guard NetworkMonitor.shared.status == .satisfied else {
            return
        }
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
                if keyOrValue.count < 2 {
                    return
                }
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
        let encodedUrlString = self.absoluteString
        let decodedUrlString = encodedUrlString.removingPercentEncoding ?? encodedUrlString
        if decodedUrlString.contains("://") {
            var components = decodedUrlString.components(separatedBy: "://")
            let internetProtocol = components[0] + "://"
            let urlWithoutProtocol = components[1]

            if urlWithoutProtocol.contains("/") {
                components = urlWithoutProtocol.components(separatedBy: "/")
                let baseURL = internetProtocol + components[0] + "/"
                let stringAfterBaseUrl = decodedUrlString.replacingOccurrences(of: baseURL, with: "")
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
