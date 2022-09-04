//
//  EventItemCardView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import SwiftUI

struct EventItemCardView: View {
    
    @State var vm: EventVM
    
    var body: some View {
        GeometryReader { reader in
            HStack {
                VStack {
                    Text(self.vm.event.startDate.mois().capitalizingFirstLetter())
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.red).opacity(0.8)
                    
                    Text(self.vm.event.startDate.toString(format: "dd"))
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.black).opacity(0.8)
                }
                .padding(.horizontal, 24)
                .padding(.all, 10)

                VStack(alignment: .leading, spacing: 8) {
                    Text(self.vm.event.name)
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                    
                    Text("Le \(self.vm.event.startDate.toString(format: "dd/MM/yyyy")) à \(self.vm.event.startTime)")
                        .font(.system(size: 16, weight: .medium, design: .default))
                    
                    Text(self.vm.event.group)
                        .font(.system(size: 16, weight: .medium, design: .default))
                    
                    HStack {
                        CaptionView( sfSymbolName: "checkmark.circle", label: "\(vm.event.accepted)", color: .green)
                        Spacer()
                        CaptionView( sfSymbolName: "equal.circle", label: "\(vm.event.inwaiting)", color: .orange)
                        Spacer()
                        CaptionView( sfSymbolName: "nosign", label: "\(vm.event.refused)", color: .red)
                    }
                    
                    HStack {
                        Spacer()
                        Text("Bientôt")
                            .font(.system(size: 16, weight: .heavy, design: .rounded))
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBlue).opacity(0.2))
            }
            .frame(width: reader.size.width, height: reader.size.height)
        }
        .frame(height: 152)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 16, x: 0, y: 0)
    }
}

struct CaptionView: View {
    @State var sfSymbolName: String
    @State var label: String
    @State var color: Color = Color(UIColor.label)
    
    var body: some View {
        HStack(spacing: 8.0) {
            Image(systemName: self.sfSymbolName)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
            
            Text(self.label)
                .foregroundColor(color)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
    }
}


struct EventItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventItemCardView(vm: EventVM())
    }
}
