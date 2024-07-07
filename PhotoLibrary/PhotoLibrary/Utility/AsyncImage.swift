//
//  AsyncImage.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 26/05/24.
//
import SwiftUI
import Photos

struct AsyncImage: View {
    let asset: PHAsset
    @State private var image: UIImage?
    @State private var viewSize: CGSize = .zero

    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray
                    .onAppear {
                        self.viewSize = geometry.size
                        self.loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        let targetSize = CGSize(width: viewSize.width * UIScreen.main.scale, height: viewSize.height * UIScreen.main.scale)
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat

        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { (image, _) in
            self.image = image
        }
    }
}
