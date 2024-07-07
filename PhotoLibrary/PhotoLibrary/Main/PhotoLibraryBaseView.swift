//
//  PhotoLibraryBaseView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 07/05/24.
//
import SwiftUI
import AVKit
import Photos
import PDFKit

struct PhotoLibraryBaseView: View {
    @State private var selectedSegment = 0
    @State private var showModal = false
    @State private var selectedMediaIndex:Int = 0
    @State private var isFullSizePreviewPresented = false
    @State private var images: [PHAsset] = []
    @State private var videos: [PHAsset] = []
    @State private var selectedImage: UIImage? = nil
    @State private var selectedVideoURL: URL? = nil
    @State private var showActionSheet = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary

    @StateObject private var photoLibraryManager = PhotoLibraryManager()
    @StateObject private var imageModel = ImageGridViewModel()
    @StateObject private var videoModel = VideoGridViewModel()

    var body: some View {
        VStack {
            if photoLibraryManager.authorizationStatus == .authorized ||
                photoLibraryManager.authorizationStatus == .restricted{
                // Top Segmented Control
                HStack {
                    Spacer()
                    Picker(selection: $selectedSegment, label: Text("")) {
                        Text("Image").tag(0)
                        Text("Video").tag(1)
                        Text("PDF").tag(2)
                        Text("Websites").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 20)
                    .frame(width: 500)
                    
                    Spacer()
                    // Right navigation button - Upload
                    Button(action: {
                        self.showActionSheet.toggle()
                    }) {
                        Image(systemName: "photo.badge.plus.fill")
                            .padding(6)
                            .foregroundColor(.white)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(8.0)
                    }
                    .padding(.top, 20)
                    .padding(.trailing,20)
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Select Source"), buttons: [
                            .default(Text("Camera")) {
                                self.imagePickerSourceType = .camera
                                self.showModal.toggle()
                            },
                            .default(Text("Photo Library")) {
                                self.imagePickerSourceType = .photoLibrary
                                self.showModal.toggle()
                            },
                            .cancel()
                        ])
                    }
                }
                // Content based on selected segment
                switch selectedSegment {
                case 0:
                    ImageGridView(selectedMediaIndex: $selectedMediaIndex, isFullSizePreviewPresented: $isFullSizePreviewPresented, images: $imageModel.images)
                case 1:
                    VideoGridView(selectedMediaIndex: $selectedMediaIndex, isFullSizePreviewPresented: $isFullSizePreviewPresented, videos: $videoModel.videos)
                case 2:
                    DocumentView()
                    Spacer()
                default:
                    WebsiteView()
                    Spacer()
                }
            }else{
                VStack {
                    Text("Please grant access to photos in Settings.")
                    Button(action: {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Text("Open Settings")
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8.0)
                    }
                }
                
            }
        }
        .onAppear {
            photoLibraryManager.checkAuthorizationStatus()
        }
        .sheet(isPresented: $showModal) {
            ImagePicker(selectedImage: $selectedImage, selectedVideoURL: $selectedVideoURL, sourceType: imagePickerSourceType)
        }
        .fullScreenCover(isPresented: $isFullSizePreviewPresented) {
            ZStack {
                BackgroundBlurView()
                if selectedSegment == 0 {
                    FullSizePreview(selectedMediaIndex: $selectedMediaIndex,
                                    medias: $imageModel.images)
                    .presentationBackground(Color.black.opacity(0.8))
                }else if selectedSegment == 1 {
                    FullSizePreview(selectedMediaIndex: $selectedMediaIndex,
                                    medias:$videoModel.videos)
                    .presentationBackground(Color.black.opacity(0.8))
                }
            }
        }
        .onChange(of: selectedImage) { newImage in
            if let image = newImage {
                imageModel.addImage(image) {
                    self.selectedImage = nil
                }
            }
        }
        .onChange(of: selectedVideoURL) { newVideoURL in
            if let videoURL = newVideoURL {
                videoModel.addVideo(videoURL) {
                    self.selectedVideoURL = nil
                }
            }
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    view.alpha = 0.1 // Adjust alpha for desired transparency
    return view
  }

  func updateUIView(_ uiView: UIView, context: Context) { }
}

struct UploadView: View {
    var body: some View {
        Text("Upload View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoLibraryBaseView()
    }
}
