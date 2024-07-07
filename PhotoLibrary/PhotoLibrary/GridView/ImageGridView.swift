//
//  ImageGridView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct ImageGridView: View {
    @Binding var selectedMediaIndex: Int
    @Binding var isFullSizePreviewPresented: Bool
    @Binding var images: [PHAsset]
    
    @StateObject private var viewModel = ImageGridViewModel()
    @StateObject private var orientationChangeNotifier = OrientationChangeNotifier()

    let cellHeight: CGFloat = 200.0
    private var columns: [GridItem] {
        if orientationChangeNotifier.orientation.isLandscape {
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ]
        }
    }
    
    private var cellWidth: CGFloat {
        let numberOfColumns = CGFloat(columns.count)
        return (UIScreen.main.bounds.width - (16.0 * (numberOfColumns + 1))) / numberOfColumns
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.images.indices, id: \.self) { index in
                    ImageCell(asset: viewModel.images[index])
                        .frame(width: cellWidth, height: cellHeight)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .clipped()
                        .onTapGesture {
                            self.selectedMediaIndex = index
                            self.images = viewModel.images
                            self.isFullSizePreviewPresented.toggle()
                        }
                        .tag(index)
                }
            }
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.fetchImages()
            }
        }
    }
}
