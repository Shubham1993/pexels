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
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: video.thumbnailURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure(_), .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))

                @unknown default:
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
            }
            .frame(width: width, height: height)
            .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.75)],
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(width: width, height: height)

            VStack(alignment: .leading, spacing: 2) {
                Text(video.videographerName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(DurationFormatter.string(from: video.duration))
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
            }
            .padding(6)
            .frame(width: width, alignment: .leading)
        }
        .frame(width: width, height: height)
        .background(Color.gray.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}

enum DurationFormatter {
    static func string(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%d:%02d", minutes, remaining)
    }
}
