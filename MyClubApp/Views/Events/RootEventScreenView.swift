//
//  RootEventScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI

struct RootEventScreenView: View {
    let imagePaths: [String: String]  = [
        "Events": "calendar.badge.clock",
        "Historique": "bell.fill",
        "Groupes": "person.2.circle",
        "Messages": "message.fill"
    ]
    @State var currentTab: String = "Events"
    
    var body: some View {
        TabView {
            EventHomeScreenView()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Événements")
                }
            HistoricView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Historique")
                }
            RootGroupScreenView()
                .tabItem {
                    Image(systemName: "person.2.circle")
                    Text("Groupes")
                }
            MessagesView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Messages")
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
        RootEventScreenView()
    }
}
