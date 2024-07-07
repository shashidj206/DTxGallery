//
//  VideoGridView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct VideoGridView: View {
    @Binding var selectedMediaIndex:Int
    @Binding var isFullSizePreviewPresented: Bool
    @Binding var videos: [PHAsset]

    @StateObject private var viewModel = VideoGridViewModel()
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
                ForEach(viewModel.videos.indices, id: \.self) { index in
                    VideoCell(asset: viewModel.videos[index])
                        .frame(width: cellWidth, height: cellHeight)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(16)
                        .onTapGesture {
                            self.selectedMediaIndex = index
                            self.videos = viewModel.videos
                            self.isFullSizePreviewPresented.toggle()
                        }
                        .tag(index)
                }
            }
            .padding(.horizontal, 16)
            .onAppear {
                viewModel.fetchVideos()
            }
        }
    }
}
