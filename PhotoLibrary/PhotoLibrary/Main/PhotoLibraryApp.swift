//
//  PhotoLibraryApp.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 07/05/24.
//

import SwiftUI

@main
struct PhotoLibraryApp: App {
    var body: some Scene {
        WindowGroup {
            PhotoLibraryBaseView()
                .preferredColorScheme(.dark)
        }
    }
}
