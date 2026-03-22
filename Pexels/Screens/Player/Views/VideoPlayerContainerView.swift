//
//  VideoPlayerContainerView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI
import AVKit

struct VideoPlayerContainerView: UIViewControllerRepresentable {
    let player: AVPlayer
    @Binding var isFullscreen: Bool

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.entersFullScreenWhenPlaybackBegins = false
        controller.exitsFullScreenWhenPlaybackEnds = false
        return controller
    }

    func updateUIViewController(_ controller: AVPlayerViewController, context: Context) {
        controller.player = player
    }
}
