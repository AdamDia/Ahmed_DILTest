//
//  ColorPickerView.swift
//  Ghost drawing board
//
//  Created by Adam Essam on 25/09/2023.
//

import SwiftUI

struct ColorPickerView: View {
    
    let colors = [Color.red, Color.blue, Color.green]
    @Binding var selectedColor: Color?
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
            
                Image(systemName: selectedColor == color ? Constants.Icons.recordCircleFill : Constants.Icons.circleFill)
                    .foregroundColor(color)
                    .font(.system(size: 30))
                    .clipShape(Circle())
                    .onTapGesture {
                        selectedColor = color
                    }
            }
        }
    }
}

struct ColorListView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.blue))
    }
}
