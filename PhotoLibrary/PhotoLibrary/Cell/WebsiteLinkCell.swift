//
//  WebsiteLinkCell.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 05/07/24.
//

import SwiftUI

struct WebsiteLinkCell: View {
    let link: String
    let width: CGFloat
    @Binding var isInEditMode: Bool
    @Binding var showDeleteConfirmation: Bool
    @Binding var showURLEditAlert: Bool
    @Binding var newWebsiteURL: String
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(width: width)
                    .padding()
                Text(link)
                    .font(.caption)
                    .lineLimit(2)
                    .padding(.leading, 40)
                    .padding(.trailing, 40)
            }

            if isInEditMode {
                VStack {
                    HStack {
                        Button(action: {
                            showURLEditAlert = true
                            newWebsiteURL = link
                            onEdit()
                        }) {
                            Image(systemName: "slider.horizontal.2.gobackward")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                                .padding(.top, 24)
                                .padding(.leading, 30)
                        }
                        Spacer()
                        Button(action: {
                            showDeleteConfirmation = true
                            onDelete()
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
}
