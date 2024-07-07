//
//  ImageCell.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct ImageCell: View {
    let asset: PHAsset
    var isInPreview = false

    var body: some View {
        ZStack {
            ImageView()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.white.opacity(0.4), radius: 5, x: 0, y: 0)
        }
    }
    
    @ViewBuilder private func ImageView() -> some View {
        if isInPreview {
            AsyncImage(asset: asset)
                .aspectRatio(1.0, contentMode: .fit)
        }else{
            AsyncImage(asset: asset)
                .aspectRatio(1.0, contentMode: .fill)
        }
    }
}
