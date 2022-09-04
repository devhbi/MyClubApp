//
//  EventHomeScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 04/09/2022.
//

import SwiftUI

struct EventHomeScreenView: View {
    @ObservedObject var eventListVM = EventListVM()
    @State var showAddEventSheetView: Bool = false
    @State private var numberOfRows = 1
    @EnvironmentObject var accountVM: AccountViewModel
    let spacing: CGFloat = 10
    @State private var selectedTabIndex = 0
    var body: some View {
        VStack(alignment: .leading) {
            SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Événements", "Posts"])
            if selectedTabIndex == 0 {
                EventScreenView()
            }
            else {
                PostScreenView()
            }
            Spacer()
        }
        .padding(.top, 50)
        .animation(nil, value: UUID())

    }
}

struct EventHomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        EventHomeScreenView()
    }
}
