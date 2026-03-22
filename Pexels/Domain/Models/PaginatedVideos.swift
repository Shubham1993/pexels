//
//  PaginatedVideos.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct PaginatedVideos: Hashable {
    let page: Int
    let perPage: Int
    let videos: [VideoItem]
    let totalResults: Int
    let nextPageURL: String?
    let hasMore: Bool
}
