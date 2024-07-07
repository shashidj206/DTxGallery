//
//  FullSizePreview.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct FullSizePreview: View {
    @Binding var selectedMediaIndex:Int
    @Binding var medias: [PHAsset]
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var orientationChangeNotifier = OrientationChangeNotifier()

    let imageSpacing: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .center) { // Align close button to the top trailing corner
                TabView(selection: $selectedMediaIndex) {
                    ForEach(medias.indices, id: \.self) { index in
                        mediaViewFor(media: medias[index])
                            .frame(width: imageWidth, height: imageHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            .tag(index)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss() // Dismiss the presented view
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .padding()
                        }
                        .padding(.top, 4)
                        .padding(.trailing, 4)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder private func mediaViewFor(media:PHAsset) -> some View {
        switch media.mediaType{
        case .image:
            ImageCell(asset: media, isInPreview: true)
        default:
            VideoCell(asset: media, isInPreview: true)
        }
    }
    
    private var imageWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    private var imageHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}




