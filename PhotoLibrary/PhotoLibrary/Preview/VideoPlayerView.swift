//
//  VideoPlayerView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 23/05/24.
//

import SwiftUI
import AVKit
import Photos

struct VideoPlayerView: View {
    let asset: PHAsset
    @Binding var isPlaying: Bool
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        if isPlaying {
                            player.play()
                        } else {
                            player.pause()
                        }
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                Text("Loading video...")
                    .onAppear {
                        loadVideo()
                    }
            }
        }
    }
    
    private func loadVideo() {
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, audioMix, info) in
            guard let avAsset = avAsset else { return }
            
            DispatchQueue.main.async {
                let playerItem = AVPlayerItem(asset: avAsset)
                self.player = AVPlayer(playerItem: playerItem)
                if isPlaying {
                    self.player?.play()
                }
            }
        }
    }
}
