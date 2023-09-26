//
//  DrawingBoardViewModel.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 25/09/2023.
//

import SwiftUI

class DrawingBoardViewModel: ObservableObject {
    @Published var paths: [Color: [DrawingSegment]] = [.red: [], .blue: [], .green: [], .clear: []]
    var currentSegment: [DrawingSegment] = []
    var eraserPoints: [CGPoint] = []
    private let eraserRadius: CGFloat = 5.0
    
    func handleDragChanged(for tool: DrawingTool, startLocation: CGPoint, location: CGPoint, thickness: CGFloat) {
           if tool == .eraser {
               eraserPoints.append(location)
               return
           }
           
           let newSegmentStart = currentSegment.last?.end ?? startLocation
           let newSegment = DrawingSegment(start: newSegmentStart, end: location, lineWidth: thickness)
           currentSegment.append(newSegment)
       }

       func handleDragEnded(for tool: DrawingTool, with toolDelays: [DrawingTool: Double], and getColor: (DrawingTool) -> Color) {
           let delay = toolDelays[tool] ?? 0.0
           
           if tool == .eraser {
               for point in eraserPoints {
                   DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                       guard let self = self else { return }
                       self.erase(at: point, with: self.eraserRadius)
                   }
               }
               eraserPoints.removeAll()
               return
           }
           
           guard currentSegment.count > 1 else { return }
           let color = getColor(tool)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
               guard let self = self else { return }
               self.paths[color, default: []].append(contentsOf: self.currentSegment)
               self.currentSegment.removeAll()
           }
       }

    func erase(at point: CGPoint, with radius: CGFloat) {
        for (color, segments) in paths {
            paths[color] = segments.filter { segment in
                !isPoint(point, closeToSegment: segment, within: radius)
            }
        }
    }

    private func isPoint(_ point: CGPoint, closeToSegment segment: DrawingSegment, within distance: CGFloat) -> Bool {
        let closestPoint = point.closestPoint(toSegmentFrom: segment.start, to: segment.end)
        let d = hypot(point.x - closestPoint.x, point.y - closestPoint.y)
        return d <= distance
    }
}

