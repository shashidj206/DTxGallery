//
//  DocumentGridView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI
import Photos

struct DocumentGridView: View {
    @ObservedObject var viewModel: DocumentGridViewModel
    @State private var selectedDocument: URL?
    @StateObject private var orientationChangeNotifier = OrientationChangeNotifier()
    @State private var showDeleteButton = false
    @State private var showDeleteConfirmation = false
    
    let cellHeight: CGFloat = 200.0
    
    private var columns: [GridItem] {
        if orientationChangeNotifier.orientation.isLandscape {
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ]
        }
    }
    
    private var cellWidth: CGFloat {
        let numberOfColumns = CGFloat(columns.count)
        return (UIScreen.main.bounds.width - (16.0 * (numberOfColumns + 1))) / numberOfColumns
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.documents.indices, id: \.self) { index in
                    DocumentCell(document: viewModel.documents[index],
                                 width: cellWidth,
                                 showDeleteButton: $showDeleteButton,
                                 showDeleteConfirmation: $showDeleteConfirmation)
                    .frame(width: cellWidth, height: cellHeight)
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(16)
                    .onTapGesture {
                        if showDeleteButton == false {
                            selectedDocument = viewModel.documents[index]
                            if let doc = selectedDocument {
                                viewModel.openDocument(doc)
                            }
                        }else{
                            showDeleteButton = false
                        }
                    }
                    .onLongPressGesture {
                        showDeleteButton.toggle()
                    }
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(title: Text("Delete"),
                              message: Text("Are you sure you want to delete this document?"),
                              primaryButton:
                                .default(Text("Delete")) {
                                    viewModel.deleteDocument(at: viewModel.documents[index])
                                },
                              secondaryButton: .cancel(Text("Cancel")))
                    }
                    .tag(index)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
