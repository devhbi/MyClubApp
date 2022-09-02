//
//  EventsView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI

struct EventScreenView: View {
    let imagePaths: [String: String]  = [
        "Events": "calendar.badge.clock",
        "Historique": "bell.fill",
        "Groupes": "person.2.circle",
        "Messages": "message.fill"
    ]
    @State var currentTab: String = "Events"
    
    var body: some View {
        // Whole Navigation View
        HStack(spacing: 0) {
            
            // Main Tab View
            VStack(spacing: 0) {
                TabView (selection: self.$currentTab){
                    RootEventScreenView()
                        .tag("Events")
                    
                    HistoricView()
                        .tag("Historique")
                    
                    GroupDashboardView()
                        .tag("Groupes")
                    
                    MessagesView()
                        .tag("Messages")
                }
                Divider()
                VStack(spacing: 0) {
                    // Custom Tab Bar ...
                    HStack (spacing: 0) {
                        // Tab button
                        TabButton(image: "Events")
                        
                        TabButton(image: "Historique")
                        
                        TabButton(image: "Groupes")
                        
                        TabButton(image: "Messages")
                    }
                    .padding([.all], 15)
                }
            }
        }
    }
    
    @ViewBuilder
    func TabButton (image: String) -> some View {
        Button {
            withAnimation{
                currentTab = image
            }
        }
        label: {
            Image(systemName: imagePaths[image]!)
                .font(.title)
                .aspectRatio(contentMode: .fit)
                .frame(width: 22, height: 22)
                .foregroundColor(currentTab == image ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventScreenView()
    }
}
