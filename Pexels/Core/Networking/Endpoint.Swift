//
//  Endpoint.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

enum Endpoint {
    case popularVideos(page: Int, perPage: Int)
    
    var path: String {
        switch self {
        case .popularVideos:
            return "/videos/popular"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popularVideos:
            return .GET
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .popularVideos(let page, let perPage):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
        }
    }
}
