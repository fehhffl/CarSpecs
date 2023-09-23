//
//  APIErrors.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

enum APIError: LocalizedError {
    case invalidEndpoint
    case malformedURL
    case missingEndpoint
    case missingPageNumber
    case missingURL

    var errorDescription: String? {
        switch self {
        case .invalidEndpoint:
            return "The endpoint provided it not valid"
        case .malformedURL:
            return "Something is wrong with the URL format"
        case .missingEndpoint:
            return "Couldn't find any endpoint specified after the baseUrl"
        case .missingPageNumber:
            return "Failed to find query parameter \"page\" in the URL"
        case .missingURL:
            return "No URL provided to the request"
        }
    }
}
