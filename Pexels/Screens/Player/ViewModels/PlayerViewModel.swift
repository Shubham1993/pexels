//
//  PlayerViewModel.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import Foundation
import AVFoundation

@MainActor
final class PlayerViewModel: ObservableObject {
    @Published private(set) var currentVideo: VideoItem
    @Published private(set) var upNextVideos: [VideoItem]

    let player = AVPlayer()

    private var queue: [VideoItem]
    private var currentIndex: Int
    private var playbackObserver: NSObjectProtocol?

    init(currentVideo: VideoItem, queue: [VideoItem], currentIndex: Int) {
        self.currentVideo = currentVideo
        self.queue = queue
        self.currentIndex = currentIndex
        self.upNextVideos = Array(queue.dropFirst(currentIndex + 1))

        configurePlayer(for: currentVideo)
        observePlaybackEnd()
    }
    
    deinit {
        if let playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }

    func play(video: VideoItem) {
        guard let index = queue.firstIndex(of: video) else { return }
        currentIndex = index
        currentVideo = video
        upNextVideos = Array(queue.dropFirst(currentIndex + 1))
        configurePlayer(for: video)
    }

    func playNextIfAvailable() {
        let nextIndex = currentIndex + 1
        guard queue.indices.contains(nextIndex) else { return }
        let nextVideo = queue[nextIndex]
        play(video: nextVideo)
    }

    func stopPlayback() {
        player.pause()
        player.replaceCurrentItem(with: nil)
    }

    private func configurePlayer(for video: VideoItem) {
        guard let url = video.playbackURL else { return }
        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)
        player.play()
    }

    private func observePlaybackEnd() {
        playbackObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.playNextIfAvailable()
        }
    }
}
