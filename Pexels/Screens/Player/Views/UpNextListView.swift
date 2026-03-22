//
//  UpNextListView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI

struct UpNextListView: View {
    let videos: [VideoItem]
    let onTap: (VideoItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Next Up")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(videos) { video in
                        Button {
                            onTap(video)
                        } label: {
                            HStack(spacing: 12) {
                                AsyncImage(url: video.thumbnailURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Rectangle().fill(Color.gray.opacity(0.2))
                                }
                                .frame(width: 120, height: 72)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(video.videographerName)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)

                                    Text(DurationFormatter.string(from: video.duration))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}


