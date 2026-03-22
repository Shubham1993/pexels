//
//  DecodingError.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

extension DecodingError {
    var prettyDescription: String {
        switch self {

        case .typeMismatch(let type, let context):
            return """
            Type mismatch for type: \(type)
            CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            Description: \(context.debugDescription)
            """

        case .valueNotFound(let type, let context):
            return """
            Value not found for type: \(type)
            CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            Description: \(context.debugDescription)
            """

        case .keyNotFound(let key, let context):
            return """
            Missing key: \(key.stringValue)
            CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            Description: \(context.debugDescription)
            """

        case .dataCorrupted(let context):
            return """
            Data corrupted
            CodingPath: \(context.codingPath.map { $0.stringValue }.joined(separator: " -> "))
            Description: \(context.debugDescription)
            """

        @unknown default:
            return "Unknown decoding error"
        }
    }
}
