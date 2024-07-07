//
//  OrientationChangeNotifier.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 02/07/24.
//

import SwiftUI
import Combine

class OrientationChangeNotifier: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation
    
    private var cancellable: AnyCancellable?
    
    init() {
        self.orientation = UIDevice.current.orientation
        
        self.cancellable = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .map { _ in UIDevice.current.orientation }
            .assign(to: \.orientation, on: self)
    }
}
