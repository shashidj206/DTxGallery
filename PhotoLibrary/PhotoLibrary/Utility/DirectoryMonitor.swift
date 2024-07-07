//
//  DirectoryMonitor.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 05/07/24.
//

import Foundation

class DirectoryMonitor {
    private let fileDescriptor: CInt
    private let source: DispatchSourceFileSystemObject
    let url: URL
    
    var directoryDidChange: (() -> Void)?
    
    init?(url: URL) {
        self.url = url
        
        fileDescriptor = open(url.path, O_EVTONLY)
        if fileDescriptor == -1 {
            print("Failed to open file descriptor")
            return nil
        }
        
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: DispatchQueue.global())
        
        source.setEventHandler { [weak self] in
            self?.directoryDidChange?()
        }
        
        source.setCancelHandler {
            close(self.fileDescriptor)
        }
    }
    
    deinit {
        stopMonitoring()
    }
    
    func startMonitoring() {
        source.resume()
        print("Started monitoring directory at \(url.path)")
    }
    
    func stopMonitoring() {
        source.cancel()
        print("Stopped monitoring directory at \(url.path)")
    }
}
