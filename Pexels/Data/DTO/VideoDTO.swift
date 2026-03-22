//
//  VideoDTO.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

struct VideoDTO: Decodable {
    let id: Int
    let width: Int?
    let height: Int?
    let duration: Int
    let url: String?
    let image: String?
    let user: UserDTO?
    let videoFiles: [VideoFileDTO]
    let videoPictures: [VideoPictureDTO]?

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case duration
        case url
        case image
        case user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"
    }

    func toDomain() -> VideoItem? {
        let urls = videoFiles.compactMap { URL(string: $0.link) }
        let selected = VideoFileSelector.bestURL(from: videoFiles)
        let title = user?.name ?? "Video \(id)"
        return VideoItem(
            id: id,
            title: title,
            thumbnailURL: URL(string: image!),
            videographerName: user!.name,
            duration: duration,
            playbackURL: selected,
            allPlaybackURLs: urls
        )
    }
}
