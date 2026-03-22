//
//  HomeView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    private let spacing: CGFloat = 8
    private let horizontalPadding: CGFloat = 16

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                let totalSpacing = spacing * 2
                let totalHorizontal = horizontalPadding * 2
                let itemWidth = (geo.size.width - totalHorizontal - totalSpacing) / 3
                let itemHeight = itemWidth * 1.6

                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: spacing), count: 3),
                        spacing: spacing
                    ) {
                        ForEach(viewModel.videos) { video in
                            NavigationLink {
                                PlayerView(
                                    viewModel: PlayerViewModel(
                                        currentVideo: video,
                                        queue: viewModel.videos,
                                        currentIndex: viewModel.videos.firstIndex(of: video) ?? 0
                                    )
                                )
                            } label: {
                                VideoGridCardView(
                                    video: video,
                                    width: itemWidth,
                                    height: itemHeight
                                )
                            }
                            .buttonStyle(.plain)
                            .task {
                                await viewModel.loadMoreIfNeeded(currentItem: video)
                            }
                        }
                    }
                    .padding(.horizontal, horizontalPadding)
                    .padding(.top, 8)

                    if viewModel.isLoadingMore {
                        ProgressView()
                            .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Videos")
            .task {
                await viewModel.loadInitialIfNeeded()
            }
        }
    }
}
