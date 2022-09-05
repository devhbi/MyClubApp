//
//  CreateNewEventView.swift
//  MyClubApp
//
//  Created by Pole Star on 05/09/2022.
//

import SwiftUI

struct CreateNewEventView: View {
    @StateObject var presentedView: CreateEventRouter
    @ObservedObject var eventListVM: EventListVM
    @ObservedObject var groupVM = GroupVM()
    @ObservedObject var eventVM: EventVM = EventVM()
    var body: some View {
        switch presentedView.currentView {
            case .action:
                SelectActionView(eventVM: self.eventVM, presentedView: self.presentedView)
            case .group:
                SelectGroupEventView(groupVM: self.groupVM, eventVM: self.eventVM, presentedView: self.presentedView)
            case .form:
                AddNewEventView(eventVM: self.eventVM, presentedView: self.presentedView)
        }
    }
}

struct CreateNewEventView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewEventView(presentedView: CreateEventRouter(), eventListVM: EventListVM())
    }
}
