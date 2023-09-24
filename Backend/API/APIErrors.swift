//
//  APIErrors.swift
//  Backend
//
//  Created by Gabriel Carvalho on 23/09/23.
//

import Foundation

enum APIError: LocalizedError {
    case carNotFound
    case invalidCarId
    case invalidEndpoint
    case malformedQueryParams
    case malformedURL
    case missingCarId
    case missingEndpoint
    case missingPageNumber
    case missingURL

    var errorDescription: String? {
        switch self {
        case .carNotFound:
            return "No car was found with the id provided"
        case .invalidCarId:
            return "The car id informed was not parsable to Int"
        case .invalidEndpoint:
            return "The endpoint provided it not valid"
        case .malformedQueryParams:
            return "There's too many ? on the query params, it should have only one.\nIf you are trying to separate query params, use & instead"
        case .malformedURL:
            return "Something is wrong with the URL format"
        case .missingCarId:
            return "Couldn't find cad id after: details/"
        case .missingEndpoint:
            return "Couldn't find any endpoint specified after the baseUrl"
        case .missingPageNumber:
            return "Failed to find query parameter \"page\" in the URL"
        case .missingURL:
            return "No URL provided to the request"
        }
    }
}
