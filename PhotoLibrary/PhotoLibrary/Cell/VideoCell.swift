//
//  VideoCell.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct VideoCell: View {
    let asset: PHAsset
    @State private var isPlaying = false
    var isInPreview = false

    var body: some View {
        ZStack {
            if isPlaying {
                VideoPlayerView(asset: asset, isPlaying: $isPlaying)
                    //.clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.white.opacity(0.4), radius: 5, x: 0, y: 0)
                    .zIndex(1)
            } else {
                ZStack {
                    VideoView()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.white.opacity(0.4), radius: 5, x: 0, y: 0)
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            if  isInPreview == true {
                                isPlaying.toggle()
                            }
                        }
                }
            }
        }
        .onAppear(perform: {
            isPlaying = isInPreview
        })
    }
    
    @ViewBuilder private func VideoView() -> some View {
        if isInPreview {
            AsyncImage(asset: asset)
                .aspectRatio(1.0, contentMode: .fill)
        }else{
            AsyncImage(asset: asset)
                .aspectRatio(1.0, contentMode: .fill)
        }
    }
}
