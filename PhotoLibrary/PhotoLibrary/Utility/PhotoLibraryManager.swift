//
//  PhotoLibraryManager.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import Photos
import SwiftUI

class PhotoLibraryManager: ObservableObject {
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined

    init() {
        checkAuthorizationStatus()
    }

    func checkAuthorizationStatus() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .notDetermined {
            requestAuthorization()
        } else {
            self.authorizationStatus = status
        }
    }

    func requestAuthorization() {
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                self.authorizationStatus = status
            }
        }
    }
}

