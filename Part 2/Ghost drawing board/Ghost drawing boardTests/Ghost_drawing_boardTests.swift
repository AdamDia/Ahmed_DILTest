//
//  Ghost_drawing_boardTests.swift
//  Ghost drawing boardTests
//
//  Created by Adam Essam on 25/09/2023.
//

@testable import Ghost_drawing_board
import XCTest
import SwiftUI

class DrawingBoardViewModelTests: XCTestCase {
    
    var viewModel: DrawingBoardViewModel!
    
    override func setUpWithError() throws {
        viewModel = DrawingBoardViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testEraseWithNoPathsDoesNotFail() {
        // Given there are no segments
        // When trying to erase
        viewModel.erase(at: CGPoint(x: 0, y: 0), with: 5)
        // Then it shouldn't fail (no assert is needed because we're testing that no error occurs)
    }
    
    func testEraseRemovesCloseSegments() {
        // Given a segment close to a point
        let closeSegment = DrawingSegment(start: CGPoint(x: 5, y: 5), end: CGPoint(x: 10, y: 10))
        viewModel.paths[.red] = [closeSegment]
        
        // When erasing at the segment
        viewModel.erase(at: CGPoint(x: 5, y: 5), with: 5)
        
        // Then the segment should be removed
        XCTAssertTrue(viewModel.paths[.red]!.isEmpty)
    }
    
    func testEraseDoesNotRemoveDistantSegments() {
        // Given a segment far from a point
        let distantSegment = DrawingSegment(start: CGPoint(x: 100, y: 100), end: CGPoint(x: 200, y: 200))
        viewModel.paths[.blue] = [distantSegment]
        
        // When erasing far from the segment
        viewModel.erase(at: CGPoint(x: 5, y: 5), with: 5)
        
        // Then the segment should not be removed
        XCTAssertEqual(viewModel.paths[.blue]!, [distantSegment])
    }
    
    func testHandleDragChangedForEraser() {
        // Given a tool is set to eraser
        let tool: DrawingTool = .eraser
        let location = CGPoint(x: 10, y: 10)
        let startLocation = location
        
        // Mock the drag gesture value for testing purposes
        viewModel.handleDragChanged(for: tool, startLocation: startLocation, location: location, thickness: 5)
        
        // Then an eraser point should be added
        XCTAssertEqual(viewModel.eraserPoints, [location])
    }
    
    func testHandleDragChangedForDrawingTool() {
        // Given a tool set to a color
        let tool: DrawingTool = .red
        let startLocation = CGPoint(x: 10, y: 10)
        let location = CGPoint(x: 20, y: 20)
        let lineWidth = 5.0
        let expectedSegment = DrawingSegment(start: startLocation, end: location, lineWidth: 5)

        // Mock the drag gesture value for testing purposes
        viewModel.handleDragChanged(for: tool, startLocation: startLocation, location: location, thickness: lineWidth)
        guard let actualSegment = viewModel.currentSegment.first else {
            XCTFail("No segment found")
            return
        }
        XCTAssertEqual(actualSegment.start, expectedSegment.start)
        XCTAssertEqual(actualSegment.end, expectedSegment.end)
        XCTAssertEqual(actualSegment.lineWidth, expectedSegment.lineWidth)
    }
    
    func testHandleDragEndedForEraser() {
        // Given a tool is set to eraser and there's a segment close to eraser point
        let tool: DrawingTool = .eraser
        let closeSegment = DrawingSegment(start: CGPoint(x: 5, y: 5), end: CGPoint(x: 10, y: 10))
        viewModel.paths[.red] = [closeSegment]
        viewModel.eraserPoints.append(CGPoint(x: 5, y: 5))
        
        // Create an expectation
        let expectation = self.expectation(description: "Erasing completed")

        // Modify your viewModel to notify when erasing is done
        viewModel.handleDragEnded(for: tool, with: [.red: 0.0], and: { _ in .red })
        
        // Fulfill the expectation after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        // Wait for expectations (with a timeout, in case something goes wrong)
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectations timed out with error: \(error)")
            } else {
                // Then the segment should be removed
                XCTAssertTrue(self.viewModel.paths[.red]!.isEmpty)
            }
        }
    }
    
    func testEraseWithBorderlineDistance() {
        // Given a segment borderline within the erasure point
        let segment = DrawingSegment(start: CGPoint(x: 5, y: 5), end: CGPoint(x: 11, y: 11))
        viewModel.paths[.red] = [segment]
        
        // When erasing at a borderline distance from the segment
        viewModel.erase(at: CGPoint(x: 14.5, y: 14.5), with: 5)
        
        // Then the segment should still be removed (due to the function's current behavior)
        XCTAssertTrue(viewModel.paths[.red]!.isEmpty)
    }
    
    func testConcurrentErasingOnMultipleColors() {
        // Given segments of multiple colors
        let redSegment = DrawingSegment(start: CGPoint(x: 5, y: 5), end: CGPoint(x: 10, y: 10))
        let blueSegment = DrawingSegment(start: CGPoint(x: 5, y: 5), end: CGPoint(x: 10, y: 10))
        viewModel.paths[.red] = [redSegment]
        viewModel.paths[.blue] = [blueSegment]
        
        // When erasing at a point
        viewModel.erase(at: CGPoint(x: 5, y: 5), with: 5)
        
        // Then the segments of both colors should be removed
        XCTAssertTrue(viewModel.paths[.red]!.isEmpty)
        XCTAssertTrue(viewModel.paths[.blue]!.isEmpty)
    }
    
}

