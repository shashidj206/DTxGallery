//
//  ImageGridViewModel.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import SwiftUI
import Photos
class ImageGridViewModel: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    @Published var images: [PHAsset] = []
    
    override init() {
        super.init()
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.fetchImages()
        }
    }
    
    func fetchImages() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        
        DispatchQueue.main.async {
            self.images.removeAll()
            var newImages: [PHAsset] = []
            fetchResult.enumerateObjects { (asset, _, _) in
                newImages.append(asset)
            }
            self.images = newImages
        }
    }
    
    func addImage(_ image: UIImage, completion: @escaping () -> Void) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { success, error in
            if success {
                DispatchQueue.main.async {
                    self.fetchImages()
                    completion()
                }
            } else if let error = error {
                print("Error saving image: \(error.localizedDescription)")
            }
        })
    }
}
