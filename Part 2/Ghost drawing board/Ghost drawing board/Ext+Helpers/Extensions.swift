//
//  Extensions.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 25/09/2023.
//

import Foundation

extension CGPoint {
    func closestPoint(toSegmentFrom start: CGPoint, to end: CGPoint) -> CGPoint {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let lengthSquared = dx * dx + dy * dy
        
        let t = max(0, min(1, ((self.x - start.x) * dx + (self.y - start.y) * dy) / lengthSquared))
        
        return CGPoint(x: start.x + t * dx, y: start.y + t * dy)
    }
}
