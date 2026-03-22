//
//  VideoResponseDTO.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct VideoResponseDTO: Decodable {
    let page: Int
    let perPage: Int
    let videos: [VideoDTO]
    let totalResults: Int
    let nextPage: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case videos
        case totalResults = "total_results"
        case nextPage = "next_page"
        case url
    }

    func toDomain() -> PaginatedVideos {
        let mappedVideos = videos.compactMap { $0.toDomain() }
        return PaginatedVideos(
            page: page,
            perPage: perPage,
            videos: mappedVideos,
            totalResults: totalResults,
            nextPageURL: nextPage,
            hasMore: nextPage != nil && !mappedVideos.isEmpty
        )
    }
}
