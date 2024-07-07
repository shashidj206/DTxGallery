//
//  VideoGridViewModel.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import Foundation
import Photos

class VideoGridViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var videos: [PHAsset] = []
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.fetchVideos()
        }
    }
    
    func fetchVideos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: options)
        DispatchQueue.main.async {
            fetchResult.enumerateObjects { (asset, _, _) in
                self.videos.append(asset)
            }
        }
    }
    
    func addVideo(_ url: URL, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.fetchVideos()
                    completion()
                }
            } else if let error = error {
                print("Error saving video: \(error.localizedDescription)")
            }
        })
    }
}
