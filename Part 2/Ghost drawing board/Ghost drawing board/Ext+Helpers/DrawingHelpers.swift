//
//  DrawingHelpers.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 25/09/2023.
//

import SwiftUI

enum DrawingTool {
    case red, blue, green, eraser
}

 func getColor(from tool: DrawingTool) -> Color {
    switch tool {
    case .red: return Color.red
    case .blue: return Color.blue
    case .green: return Color.green
    case .eraser: return Color.clear
    }
}

