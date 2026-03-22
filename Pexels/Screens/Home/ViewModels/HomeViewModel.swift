//
//  HomeViewModel.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var videos: [VideoItem] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var errorMessage: String?

    private let fetchPopularVideosUseCase: FetchPopularVideosUseCase

    private(set) var currentPage = 1
    private let perPage = 15
    private var hasMore: Bool = true
    private var hasLoadedInitially = false

    init(fetchPopularVideosUseCase: FetchPopularVideosUseCase) {
        self.fetchPopularVideosUseCase = fetchPopularVideosUseCase
    }
    
    func loadMore() async {
        guard hasMore else { return }
        guard !isLoading else { return }
        guard !isLoadingMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let result = try await fetchPopularVideosUseCase.execute(
                page: currentPage,
                perPage: perPage
            )
            guard !result.videos.isEmpty else {
                hasMore = false
                return
            }
            
            let newVideos = result.videos
            
            await MainActor.run {
                withAnimation(.none) {
                    videos.append(contentsOf: newVideos)
                }
            }
           
            hasMore = result.hasMore
            currentPage += 1

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadInitialIfNeeded() async {
        guard !hasLoadedInitially else { return }
        hasLoadedInitially = true
        await refresh()
    }
    
    func clearError() {
        errorMessage = nil
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
}
