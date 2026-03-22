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
    @State private var showFullScreenPlayer = false

    init(currentVideo: VideoItem, queue: [VideoItem], currentIndex: Int) {
        _viewModel = StateObject(
           wrappedValue: PlayerViewModel(
               currentVideo: currentVideo,
               queue: queue,
               currentIndex: currentIndex
           )
       )
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                VideoPlayerContainerView(player: viewModel.player)
                    .frame(height: 320)
                    .background(Color.black)

                Button {
                    showFullScreenPlayer = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.black.opacity(0.65))
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
        .onAppear {
            viewModel.startPlayback()
        }
        .onDisappear {
            viewModel.stopPlayback()
        }
        .fullScreenCover(isPresented: $showFullScreenPlayer) {
            FullScreenPlayerView(player: viewModel.player)
        }
    }
}
