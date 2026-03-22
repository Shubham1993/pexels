//
//  APIError.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)
    case decodingError
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid server response."
        case .serverError(let code):
            return "Server error with code \(code)."
        case .decodingError:
            return "Failed to decode response."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}
