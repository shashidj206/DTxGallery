//
//  ImagePicker.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 27/05/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            if let videoURL = info[.mediaURL] as? URL {
                parent.selectedVideoURL = videoURL
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    @Binding var selectedImage: UIImage?
    @Binding var selectedVideoURL: URL?
    @Environment(\.presentationMode) var presentationMode

    var sourceType: UIImagePickerController.SourceType = .photoLibrary

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.mediaTypes = sourceType == .camera ? ["public.image"] : ["public.image", "public.movie"]
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


