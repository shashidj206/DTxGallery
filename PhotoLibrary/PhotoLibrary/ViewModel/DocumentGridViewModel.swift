//
//  DocumentGridViewModel.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers
import QuickLook
import Combine

class DocumentGridViewModel: ObservableObject {
    @Published var documents: [URL] = []
    private var previewItemURL: URL?
    private var fileMonitor: DirectoryMonitor?
    
    init() {
        fetchDocuments()
        monitorDirectory()
    }
    
    func fetchDocuments() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let documentFiles = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            self.documents = documentFiles.filter { ["pdf", "docx", "xlsx"].contains($0.pathExtension.lowercased()) }
        } catch {
            print("Error fetching documents: \(error.localizedDescription)")
        }
    }
    
    func addDocuments(_ urls: [URL]) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        for url in urls {
            let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
            
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: url, to: destinationURL)
            } catch {
                print("Error saving document to persistent location: \(error.localizedDescription)")
            }
        }
        
        fetchDocuments()
    }
    
    func deleteDocument(at url: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: url)
            fetchDocuments()
        } catch {
            print("Error deleting document: \(error.localizedDescription)")
        }
    }
    
    private func monitorDirectory() {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        fileMonitor = DirectoryMonitor(url: documentsDirectory)
        fileMonitor?.directoryDidChange = { [weak self] in
            print("Directory did change")
            DispatchQueue.main.async {
                self?.fetchDocuments()
            }
        }
        fileMonitor?.startMonitoring()
    }
    
    func openDocument(_ url: URL) {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            print("Failed to find the root view controller.")
            return
        }
        
        DispatchQueue.main.async {
            let previewController = QLPreviewController()
            previewController.dataSource = self
            self.previewItemURL = url
            rootViewController.present(previewController, animated: true, completion: nil)
        }
    }
}

extension DocumentGridViewModel: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItemURL! as QLPreviewItem
    }    
}
    
