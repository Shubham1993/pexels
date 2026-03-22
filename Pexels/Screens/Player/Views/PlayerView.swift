//
//  PlayerView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI
import AVKit

struct PlayerView: View {
    @StateObject private var viewModel: PlayerViewModel
    @State private var showFullScreen = false

    init(viewModel: PlayerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                VideoPlayerContainerView(
                    player: viewModel.player,
                    isFullscreen: .constant(false)
                )
                .frame(height: 320)
                .background(Color.black)

                Button {
                    showFullScreen = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(12)
            }

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.currentVideo.title)
                        .font(.headline)

                    Text(viewModel.currentVideo.videographerName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Duration: \(DurationFormatter.string(from: viewModel.currentVideo.duration))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()

            Divider()

            UpNextListView(
                videos: viewModel.upNextVideos,
                onTap: { video in
                    viewModel.play(video: video)
                }
            )

            Spacer()
        }
        .navigationTitle("Player")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showFullScreen) {
            FullScreenPlayerView(player: viewModel.player)
        }
        .onDisappear {
            viewModel.stopPlayback()
        }
    }
}
