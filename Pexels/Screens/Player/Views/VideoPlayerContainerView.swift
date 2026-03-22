//
//  VideoPlayerContainerView.swift
//  Pexels
//
//  Created by shubham gupta on 22/03/26.
//

import SwiftUI
import AVKit

struct VideoPlayerContainerView: View {
    let player: AVPlayer

    var body: some View {
        VideoPlayer(player: player)
            .background(Color.black)
    }
}
