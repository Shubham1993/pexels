//
//  HomeView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel

    private let spacing: CGFloat = 8
    private let horizontalPadding: CGFloat = 16

    @State private var didTriggerLoadMore = false

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { outerGeo in
                ScrollView {
                    VStack(spacing: 0) {

                        // MARK: Grid
                        LazyVGrid(
                            columns: makeColumns(width: outerGeo.size.width),
                            spacing: spacing
                        ) {
                            ForEach(Array(viewModel.videos.enumerated()), id: \.element.id) { index, video in
                                NavigationLink {
                                    PlayerView(currentVideo: video, queue: viewModel.videos, currentIndex: index)
                                } label: {
                                    VideoGridCardView(
                                        video: video,
                                        width: itemWidth(from: outerGeo),
                                        height: itemHeight(from: outerGeo)
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 8)

                        GeometryReader { geo in
                            Color.clear
                                .frame(height: 1)
                                .onChange(of: geo.frame(in: .global).minY) { value in
                                    handleScroll(
                                        minY: value,
                                        screenHeight: outerGeo.size.height
                                    )
                                }
                        }
                        .frame(height: 1)

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding(.vertical, 16)
                        }
                    }
                }
                .navigationTitle("Videos")
            }
            .task {
                await viewModel.loadInitialIfNeeded()
            }
        }.refreshable {
            await viewModel.refresh()
        }.alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { _ in viewModel.clearError() }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private func handleScroll(minY: CGFloat, screenHeight: CGFloat) {
        let threshold: CGFloat = 150

        if minY < screenHeight + threshold {
            guard !didTriggerLoadMore else { return }

            didTriggerLoadMore = true

            Task {
                await viewModel.loadMore()
            }
        }

        if minY > screenHeight + threshold * 2 {
            didTriggerLoadMore = false
        }
    }
    
    private func makeColumns(width: CGFloat) -> [GridItem] {
        let totalSpacing = spacing * 2
        let totalPadding = horizontalPadding * 2
        let itemWidth = (width - totalPadding - totalSpacing) / 3

        return [
            GridItem(.fixed(itemWidth), spacing: spacing),
            GridItem(.fixed(itemWidth), spacing: spacing),
            GridItem(.fixed(itemWidth), spacing: spacing)
        ]
    }

    private func itemWidth(from geo: GeometryProxy) -> CGFloat {
        let totalSpacing = spacing * 2
        let totalPadding = horizontalPadding * 2
        return (geo.size.width - totalPadding - totalSpacing) / 3
    }

    private func itemHeight(from geo: GeometryProxy) -> CGFloat {
        itemWidth(from: geo) * 1.6
    }
}
