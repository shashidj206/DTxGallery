//
//  DocumentView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 25/05/24.
//

import SwiftUI

struct DocumentView: View {
    @StateObject private var viewModel = DocumentGridViewModel()
    @State private var isDocumentPickerPresented = false
    @State private var selectedDocuments: [URL] = []

    var body: some View {
        VStack {
            DocumentGridView(viewModel: viewModel)
            Spacer()
            Button(action: {
                isDocumentPickerPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "doc.viewfinder")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Select Documents")
                        .font(.system(size: 18, weight: .medium))
                }
                .padding()
                .background(Color.gray.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            Spacer()
        }
        .sheet(isPresented: $isDocumentPickerPresented) {
            DocumentPickerView(selectedURLs: $selectedDocuments)
                .onDisappear {
                    viewModel.addDocuments(selectedDocuments)
                }
        }
    }
}
