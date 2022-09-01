//
//  ItemButtonStyle.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import SwiftUI

struct ItemButtonStyle: ButtonStyle {
    let cornerRadius: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            configuration.label
            if configuration.isPressed {
                Color.black.opacity(0.2)
            }
        }
        .background(Rectangle().fill(Color.white))
        .cornerRadius(cornerRadius)
        .shadow(color: .gray, radius: 3, x: 2, y: 2)
    }
}

