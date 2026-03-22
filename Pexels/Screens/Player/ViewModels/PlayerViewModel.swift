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
    private var isActive = true
    private var queue: [VideoItem]
    private var currentIndex: Int
    private var playbackObserver: NSObjectProtocol?

    init(currentVideo: VideoItem, queue: [VideoItem], currentIndex: Int) {
        self.currentVideo = currentVideo
        self.queue = queue
        self.currentIndex = currentIndex
        self.upNextVideos = Array(queue.dropFirst(currentIndex + 1))
    }
    
    func startPlayback() {
        isActive = true
        configurePlayer(for: currentVideo)
    }

    func play(video: VideoItem) {
        guard let index = queue.firstIndex(of: video) else { return }
        currentIndex = index
        currentVideo = video
        upNextVideos = Array(queue.dropFirst(currentIndex + 1))
        isActive = true
        configurePlayer(for: currentVideo)
    }

    func stopPlayback() {
        isActive = false
        player.pause()
        player.replaceCurrentItem(with: nil)

        if let playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
            self.playbackObserver = nil
        }
    }

    private func configurePlayer(for video: VideoItem) {
        guard let url = video.playbackURL else { return }

        player.pause()

        let item = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: item)

        observePlaybackEnd(for: item)
        player.play()
    }

    private func observePlaybackEnd(for item: AVPlayerItem) {
        if let playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
            self.playbackObserver = nil
        }

        playbackObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            guard let self = self, self.isActive else { return }
            self.playNextIfAvailable()
        }
    }

    private func playNextIfAvailable() {
        let nextIndex = currentIndex + 1
        guard queue.indices.contains(nextIndex) else { return }
        play(video: queue[nextIndex])
    }

    deinit {
        if let playbackObserver {
            NotificationCenter.default.removeObserver(playbackObserver)
        }
    }
}
