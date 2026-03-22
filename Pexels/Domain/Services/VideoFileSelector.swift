//
//  VideoFileSelector.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation

enum VideoFileSelector {
    private static let preferredMobileHeight = 720

    static func bestURL(from files: [VideoFileDTO]) -> URL? {
        let mp4Files = files.filter { $0.fileType == "video/mp4" }
        guard !mp4Files.isEmpty else { return nil }

        let validFiles = mp4Files.filter { $0.height != nil }

        if let exact = validFiles.first(where: { $0.height == preferredMobileHeight }) {
            return URL(string: exact.link)
        }

        if let bestSmaller = validFiles
            .filter({ ($0.height ?? 0) < preferredMobileHeight })
            .max(by: { ($0.height ?? 0) < ($1.height ?? 0) }) {
            return URL(string: bestSmaller.link)
        }

        if let bestLarger = validFiles
            .filter({ ($0.height ?? 0) > preferredMobileHeight })
            .min(by: { ($0.height ?? 0) < ($1.height ?? 0) }) {
            return URL(string: bestLarger.link)
        }

        return URL(string: mp4Files[0].link)
    }
}
