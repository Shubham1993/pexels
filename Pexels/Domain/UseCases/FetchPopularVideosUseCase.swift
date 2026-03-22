//
//  FetchPopularVideosUseCase.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

protocol FetchPopularVideosUseCase {
    func execute(page: Int, perPage: Int) async throws -> PaginatedVideos
}

struct FetchPopularVideosUseCaseImpl: FetchPopularVideosUseCase {
    private let repository: VideoRepository

    init(repository: VideoRepository) {
        self.repository = repository
    }

    func execute(page: Int, perPage: Int) async throws -> PaginatedVideos {
        try await repository.fetchPopularVideos(page: page, perPage: perPage)
    }
}
