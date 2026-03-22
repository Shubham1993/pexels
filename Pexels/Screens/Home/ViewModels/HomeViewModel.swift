//
//  HomeViewModel.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var videos: [VideoItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?

    private let fetchPopularVideosUseCase: FetchPopularVideosUseCase

    private(set) var currentPage = 1
    private let perPage = 15
    private var hasMore = true
    private var hasLoadedInitially = false

    init(fetchPopularVideosUseCase: FetchPopularVideosUseCase) {
        self.fetchPopularVideosUseCase = fetchPopularVideosUseCase
    }

    func loadInitialIfNeeded() async {
        guard !hasLoadedInitially else { return }
        hasLoadedInitially = true
        await refresh()
    }

    func refresh() async {
        isLoading = true
        errorMessage = nil
        currentPage = 1
        hasMore = true

        do {
            let result = try await fetchPopularVideosUseCase.execute(page: currentPage, perPage: perPage)
            videos = result.videos
            hasMore = result.hasMore
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentItem: VideoItem) async {
        guard let last = videos.last else { return }
        guard currentItem.id == last.id else { return }
        guard hasMore else { return }
        guard !isLoadingMore else { return }
        guard !isLoading else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let result = try await fetchPopularVideosUseCase.execute(page: currentPage, perPage: perPage)
            videos.append(contentsOf: result.videos)
            hasMore = result.hasMore
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
