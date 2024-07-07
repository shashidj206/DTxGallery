//
//  WebsiteView.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 05/07/24.
//

import SwiftUI

struct WebsiteView: View {
    @StateObject private var viewModel = WebsiteGridViewModel()
    @State private var showAddWebsiteSheet = false
    @State private var newWebsiteURL: String = ""
    var body: some View {
        VStack {
            WebsiteGridView(viewModel: viewModel)
            Spacer()
            Button(action: {
                showAddWebsiteSheet.toggle()
            }) {
                HStack {
                    Image(systemName: "link.badge.plus")
                        .resizable()
                        .frame(width: 35, height: 30)
                    Text("Tap to enter link")
                        .font(.system(size: 18, weight: .medium))
                }
                .padding()
                .background(Color.gray.opacity(0.4))
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            Spacer()
        }
        .sheet(isPresented: $showAddWebsiteSheet) {
            VStack(spacing: 16) {
                Text("Add New Website")
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
                    viewModel.addWebsite(newWebsiteURL)
                    newWebsiteURL = ""
                    showAddWebsiteSheet = false
                }) {
                    Text("Add Website")
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
        }
    }
}
