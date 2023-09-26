//
//  DrawingSegment.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 26/09/2023.
//

import Foundation

struct DrawingSegment: Identifiable, Equatable {
    let id = UUID()
    var start: CGPoint
    var end: CGPoint
    var lineWidth: Double = 1.0
}
