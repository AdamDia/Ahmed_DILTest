//
//  DrawingBoard.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 24/09/2023.
//

import SwiftUI

struct DrawingBoard: View {
    
    @ObservedObject private var viewModel = DrawingBoardViewModel()
    @State private var currentTool: DrawingTool = .red
    @State private var currentColor: Color? = .red
    @State private var thickness: Double = 1.0
    
    
    private let eraserRadius: CGFloat = 5.0
    private var hstackPaddingEstimatedHeight: CGFloat = 60.0
    private let toolDelays: [DrawingTool: Double] = [
        .red: 1.0,
        .blue: 3.0,
        .green: 5.0,
        .eraser: 2.0
    ]
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack {
                Color.white.edgesIgnoringSafeArea(.bottom)
                VStack {
                    HStack {
                        Slider(value: $thickness, in: 1...20) {
                            Text("Thickness")
                        }.frame(maxWidth: 120)
                        
                        ColorPickerView(selectedColor: $currentColor)
                            .onChange(of: currentColor, perform: { newColor in
                                if let color = newColor {
                                    switch color {
                                    case .red:
                                        self.currentTool = .red
                                    case .blue:
                                        self.currentTool = .blue
                                    case .green:
                                        self.currentTool = .green
                                    default:
                                        break
                                    }
                                } else {
                                    self.currentTool = .eraser
                                }
                            })
                        
                        DrawingButton(action:  {
                            self.currentTool = .eraser
                            self.currentColor = nil
                        }, image: Image(systemName: Constants.Icons.eraser))
                    }
                    .padding(.top, 20)
                    
                    Spacer(minLength: 20)
                    
                    
                    ZStack {
                        Color.white
                        
                        ForEach([Color.red, Color.blue, Color.green], id: \.self) { color in
                            ForEach(viewModel.paths[color]!) { segment in
                                Path { path in
                                    path.move(to: segment.start)
                                    path.addLine(to: segment.end)
                                }
                                .stroke(color, lineWidth: segment.lineWidth)
                            }
                        }
                        
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Check if the touch is within the ZStack boundaries
                                if value.location.y >= 0 &&
                                    value.location.y <= geometry.size.height - hstackPaddingEstimatedHeight {
                                    onDragChanged(startLocation: value.startLocation, location: value.location)
                                }
                            }
                            .onEnded(onDragEnded)
                    )
                    .frame(maxWidth: .infinity)
                    
                }
            }
        }
        
    }
        
    func onDragChanged(startLocation: CGPoint, location: CGPoint) {
        viewModel.handleDragChanged(for: currentTool, startLocation: startLocation, location: location, thickness: CGFloat(thickness))

    }
    
    func onDragEnded(value: DragGesture.Value) {
        viewModel.handleDragEnded(for: currentTool, with: toolDelays, and: getColor)
    }
}

struct DrawingBoard_Previews: PreviewProvider {
    static var previews: some View {
        DrawingBoard()
    }
}
