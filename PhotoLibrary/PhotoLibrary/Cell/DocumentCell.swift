//
//  DocumentCell.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import SwiftUI

struct DocumentCell: View {
    let document: URL
    let width:CGFloat
    @Binding var showDeleteButton:Bool
    @Binding var showDeleteConfirmation:Bool
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: icon(for: document))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(width: width)
                    .padding()
                Text(document.lastPathComponent)
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
            }

            if showDeleteButton == true {
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)
                                .padding(.top, 24)
                                .padding(.trailing, 30)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    func icon(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "pdf":
            return "doc.text"
        case "txt":
            return "doc.plaintext"
        case "png", "jpg", "jpeg":
            return "photo"
        default:
            return "doc"
        }
    }
}
