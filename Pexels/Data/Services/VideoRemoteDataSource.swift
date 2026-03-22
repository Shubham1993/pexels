//
//  VideoRemoteDataSource.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

protocol VideoRemoteDataSource {
    func fetchPopularVideos(page: Int, perPage: Int) async throws -> VideoResponseDTO
}


final class VideoRemoteDataSourceImpl: VideoRemoteDataSource {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchPopularVideos(page: Int, perPage: Int) async throws -> VideoResponseDTO {
        try await apiClient.request(.popularVideos(page: page, perPage: perPage), responseType: VideoResponseDTO.self)
    }
}
