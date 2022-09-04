//
//  CheckBoxFieldView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import SwiftUI

struct CheckBoxFieldView: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int

    @Binding var isMarked: Bool /// Binding here!
    
    init(
    id: String,
    label:String,
    size: CGFloat = 16,
    color: Color = Color.black.opacity(0.68),
    textSize: Int = 14,
    isMarked: Binding<Bool>
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self._isMarked = isMarked /// to init, you need to add a _
    }
    
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle() /// just toggle without closure
        }) {
            
            HStack {
                Image(systemName: self.isMarked ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
                    .foregroundColor( self.isMarked ? .green : .cyan)

                Text(label)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(Color.black.opacity(0.87))
            }
            .foregroundColor(self.color)
            .frame(minHeight: 48, maxHeight: 64)
            
        }
    }
}

struct CheckBoxFieldView_Previews: PreviewProvider {
    @State static var isMarked: Bool = true
    static var previews: some View {
        CheckBoxFieldView(id: UUID().uuidString, label: "", isMarked: $isMarked)
    }
}
