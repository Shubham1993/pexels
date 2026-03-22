//
//  VideoGridCardView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI

struct VideoGridCardView: View {
    let video: VideoItem
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            // Background image
            AsyncImage(url: video.thumbnailURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                default:
                    Color.gray.opacity(0.2)
                }
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .overlay(
            VStack(spacing: 0) {
                Spacer()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: height * 0.4)
                .overlay(
                    VStack(alignment: .leading, spacing: 2) {
                        Text(video.videographerName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Text(DurationFormatter.string(from: video.duration))
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(6),
                    alignment: .bottomLeading
                )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}

enum DurationFormatter {
    static func string(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%d:%02d", minutes, remaining)
    }
}
