//
//  DrawingButton.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 25/09/2023.
//

import SwiftUI

struct DrawingButton: View {
    var action: () -> Void
    var image: Image
    
    var body: some View {
        Button(action: {
            action()
        }) {
            image
                .resizable()
                .foregroundColor(.gray)
                .frame(width: 25, height: 25)
        }
    }
}

struct DrawingButton_Previews: PreviewProvider {
    static var previews: some View {
        DrawingButton(action: {
            print("Dummy Eraser Action Triggered")
        }, image: Image(systemName: "eraser.fill"))
    }
}
