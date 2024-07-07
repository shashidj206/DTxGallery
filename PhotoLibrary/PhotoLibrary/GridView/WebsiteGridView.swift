//
//  WebsiteGridView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 05/07/24.
//

import SwiftUI

import SwiftUI

struct WebsiteGridView: View {
    @ObservedObject var viewModel: WebsiteGridViewModel
    @State private var selectedLinkIndex: Int? = nil
    @StateObject private var orientationChangeNotifier = OrientationChangeNotifier()
    @State private var isInEditMode = false
    @State private var showDeleteConfirmation = false
    @State private var showURLEditAlert = false
    @State private var newWebsiteURL: String = ""
    
    let cellHeight: CGFloat = 200.0
    
    private var columns: [GridItem] {
        if orientationChangeNotifier.orientation.isLandscape {
            return [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16),
            ]
        } else {
            return [
                GridItem(.flexible(), spacing: 16),
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
                ForEach(viewModel.websites.indices, id: \.self) { index in
                    WebsiteLinkCell(
                        link: viewModel.websites[index],
                        width: cellWidth,
                        isInEditMode: $isInEditMode,
                        showDeleteConfirmation: $showDeleteConfirmation,
                        showURLEditAlert: $showURLEditAlert,
                        newWebsiteURL: $newWebsiteURL,
                        onEdit: {
                            selectedLinkIndex = index
                        },
                        onDelete: {
                            selectedLinkIndex = index
                        }
                    )
                    .frame(width: cellWidth, height: cellHeight)
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(16)
                    .tag(index)
                    .onTapGesture {
                        if isInEditMode {
                            selectedLinkIndex = index
                            newWebsiteURL = viewModel.websites[index]
                            showURLEditAlert = true
                        } else {
                            if let link = URL(string: viewModel.websites[index]) {
                                viewModel.openWebsite(link)
                            }
                        }
                    }
                    .onLongPressGesture {
                        isInEditMode.toggle()
                    }
                    .alert(isPresented: $showDeleteConfirmation) {
                        Alert(
                            title: Text("Delete"),
                            message: Text("Are you sure you want to delete this Website?"),
                            primaryButton: .destructive(Text("Delete")) {
                                if let index = selectedLinkIndex {
                                    viewModel.deleteWebsite(at: index)
                                    isInEditMode = false
                                }
                            },
                            secondaryButton: .cancel {
                                isInEditMode = false
                            }
                        )
                    }
                    .sheet(isPresented: $showURLEditAlert) {
                        VStack(spacing: 16) {
                            Text("Edit Website")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.top, 32)
                           
                            TextField("Enter website URL", text: $newWebsiteURL)
                                .keyboardType(.webSearch)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .padding(.horizontal, 24)
                            
                            Button(action: {
                                if let index = selectedLinkIndex {
                                    viewModel.editWebsite(at: index, with: newWebsiteURL)
                                    newWebsiteURL = ""
                                    showURLEditAlert = false
                                    isInEditMode = false
                                }
                            }) {
                                Text("Save Website")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.4))
                                    .cornerRadius(8)
                                    .padding(.horizontal, 24)
                            }
                            .padding(.top, 16)
                            
                            Spacer()
                        }
                        .padding(.bottom, 32)
                        .onAppear {
                            viewModel.fetchWebsites()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}
