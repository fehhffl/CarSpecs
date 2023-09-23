//
//  API.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

public class API {
    private lazy var dataBase = Database.shared

    public func dataTask(with request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> Void) {
        guard let url = request.url else {
            sendResponse(for: request, statusCode: 400, error: .missingURL, completionHandler)
            return
        }
        guard let baseUrl = url.pathComponents.first, !baseUrl.isEmpty else {
            sendResponse(for: request, statusCode: 400, error: .malformedURL, completionHandler)
            return
        }

        let urlWithoutBaseUrl = url.absoluteString.replacingOccurrences(of: baseUrl, with: "")

        guard !urlWithoutBaseUrl.isEmpty else {
            sendResponse(for: request, statusCode: 400, error: .missingEndpoint, completionHandler)
            return
        }

        var endpoint = urlWithoutBaseUrl
        var queryParams: String = ""

        if urlWithoutBaseUrl.contains("?") {
            let splitedUrl = urlWithoutBaseUrl.split(separator: "?")
            endpoint = String(splitedUrl[0])
            queryParams = String(splitedUrl[1])
        }

        switch endpoint {
        case "carList":
            break
        case "details":
            break
        case "search":
            break
        case "categories":
            break
        default:
            sendResponse(for: request, statusCode: 400, error: .invalidEndpoint, completionHandler)
        }
    }

    func sendResponse(
        for request: URLRequest,
        statusCode: Int,
        data: Data? = nil,
        error: APIError? = nil,
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
}
