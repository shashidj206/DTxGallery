//
//  WebsiteGridViewModel.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 05/07/24.
//

import SwiftUI
import Combine
import SafariServices

class WebsiteGridViewModel: ObservableObject {
    @Published var websites: [String] = []
    private let fileName = "websites.txt"
    
    init() {
        fetchWebsites()
    }
    
    func fetchWebsites() {
        if let savedWebsites = retrieveStringFromFile(fileName: fileName) {
            self.websites = savedWebsites.split(separator: "\n").map { String($0) }
        } else {
            self.websites = []
        }
    }
    
    func addWebsite(_ website: String) {
        websites.append(website)
        saveWebsites()
    }
    
    func deleteWebsite(at index: Int) {
        websites.remove(at: index)
        saveWebsites()
    }
    
    private func saveWebsites() {
        let websitesString = websites.joined(separator: "\n")
        saveStringToFile(websitesString, fileName: fileName)
        fetchWebsites()
    }
    
    func editWebsite(at index: Int, with newURL: String) {
        websites[index] = newURL
        saveWebsites()
    }

    func saveStringToFile(_ string: String, fileName: String) {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            try string.write(to: fileURL, atomically: true, encoding: .utf8)
            print("String saved to file successfully.")
        } catch {
            print("Error saving string to file: \(error.localizedDescription)")
        }
    }
    
    func retrieveStringFromFile(fileName: String) -> String? {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            let savedString = try String(contentsOf: fileURL, encoding: .utf8)
            return savedString
        } catch {
            print("Error retrieving string from file: \(error.localizedDescription)")
            return nil
        }
    }
    func openWebsite(_ url: URL) {
        guard let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController else {
            print("Failed to find the root view controller.")
            return
        }
        var link = url
        if ["http", "https"].contains(url.scheme?.lowercased()) == false {
            link = URL(string: "https://\(url.absoluteString)")!
        }
        let safariViewController = SFSafariViewController(url: link)
        rootViewController.present(safariViewController, animated: true, completion: nil)
    }
}
