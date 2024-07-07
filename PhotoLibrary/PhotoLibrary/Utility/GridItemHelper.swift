//
//  GridItemHelper.swift
//  PhotoLibrary
//
//  Created by Shashidhar Jagatap on 11/05/24.
//

import SwiftUI

let spaceInItems: CGFloat = 10.0

func adaptiveGridItem(minCellWidth: CGFloat = 200, aspectRatio: CGFloat = 0.8) -> [GridItem] {
    let deviceWidth = UIScreen.main.bounds.width
    
    var columns = Int(deviceWidth / minCellWidth)
    if columns > 4 {
        columns = 3
    } else if columns < 3 {
        columns = 3
    }
    
    let cellWidth = (deviceWidth - CGFloat(columns - 1) * spaceInItems) / CGFloat(columns) // Adjust spacing as needed
    let cellHeight = cellWidth * aspectRatio
    
    return Array(repeating: GridItem(.fixed(cellHeight), spacing: spaceInItems), count: columns)
}
