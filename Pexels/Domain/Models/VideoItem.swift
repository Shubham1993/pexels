//
//  VideoItem.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct VideoItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let thumbnailURL: URL?
    let videographerName: String
    let duration: Int
    let playbackURL: URL?
    let allPlaybackURLs: [URL]
}
