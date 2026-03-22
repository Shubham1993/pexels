//
//  VideoRepository.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

protocol VideoRepository {
    func fetchPopularVideos(page: Int, perPage: Int) async throws -> PaginatedVideos
}

import Foundation

final class VideoRepositoryImpl: VideoRepository {
    private let remote: VideoRemoteDataSource

    init(remote: VideoRemoteDataSource) {
        self.remote = remote
    }

    func fetchPopularVideos(page: Int, perPage: Int) async throws -> PaginatedVideos {
        let dto = try await remote.fetchPopularVideos(page: page, perPage: perPage)
        return dto.toDomain()
    }
}
