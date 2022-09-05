//
//  GroupDetailView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import SwiftUI

struct GroupDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
    @State var showAddEventSheetView = false
    @ObservedObject var vmEvent = EventVM()
    @State var groupVM: GroupVM
    @State private var selectedTabIndex = 0
    var body: some View {
        SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Événements", "Posts", "Fichiers"])
        if self.selectedTabIndex == 0 {
            EventScreenView()
        }
        else if self.selectedTabIndex == 1 {
            PostScreenView()
        }
        else if self.selectedTabIndex == 2 {
            GroupFileView()
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(groupVM: GroupVM())
    }
}
