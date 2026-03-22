//
//  AppContainer.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

final class AppContainer {
    lazy var apiClient: APIClient = APIClientImpl(
        baseURL: URL(string: "https://api.pexels.com")!
    )

    lazy var remoteDataSource: VideoRemoteDataSource = VideoRemoteDataSourceImpl(
        apiClient: apiClient
    )

    lazy var repository: VideoRepository = VideoRepositoryImpl(
        remote: remoteDataSource
    )

    lazy var fetchPopularVideosUseCase: FetchPopularVideosUseCase = FetchPopularVideosUseCaseImpl(
        repository: repository
    )

    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(fetchPopularVideosUseCase: fetchPopularVideosUseCase)
    }
}
