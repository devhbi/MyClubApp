//
//  EntryTextFieldView.swift
//  MyClubApp
//
//  Created by Pole Star on 01/09/2022.
//

import SwiftUI

struct EntryTextFieldView: View {
    var sfSymbolName: String
    var placeHolder: String
    var promptText: String
    var isSecure: Bool = false
    
    @Binding var field: String
    
    @State var visible: Bool = false
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            VStack{
                HStack{
                    Image(systemName: self.sfSymbolName)
                        .foregroundColor(.gray)
                        .font(.headline)
                    if self.isSecure {
                        if self.visible{
                            TextField(self.placeHolder, text:self.$field)
                                .autocapitalization(.none)
                        }
                        else {
                            SecureField(self.placeHolder, text:self.$field)
                                .autocapitalization(.none)
                        }
                        
                        Button(action: {
                            self.visible.toggle()
                        }){
                            Image(systemName: self.visible ? "eye.slash.fill": "eye.fill")
                        }
                    }
                    else {
                        TextField(self.placeHolder, text:self.$field)
                            .autocapitalization(.none)
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .font(.system(size: 14))
            .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: -5, y: -5)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
            
            Text(self.promptText)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
                .foregroundColor(Color(UIColor.systemRed))
        }
    }
}

struct EntryDateFieldView: View {
    @Environment(\.colorScheme) var colorScheme
    var sfSymbolName: String
    var placeHolder: String
    var promptText: String
    @Binding var field: Date?
    
    var body: some View {
        VStack {
            LazyVStack{
                HStack{
                    Image(systemName: self.sfSymbolName)
                        .foregroundColor(.gray)
                        .font(.headline)
                    DatePickerTextField(placeholder: self.placeHolder, date: self.$field)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .font(.system(size: 14))
            .background(colorScheme == .dark ? Color(UIColor.systemBackground) : Color(red: 239.0/255.0, green: 243.0/255, blue: 244.0/255.0, opacity:1.0))
            .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: -5, y: -5)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
            
            Text(self.promptText)
                .fixedSize(horizontal: false, vertical: true)
                .font(.caption)
        }
    }
}
