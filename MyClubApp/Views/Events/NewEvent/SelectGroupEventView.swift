//
//  SelectGroupEventView.swift
//  MyClubApp
//
//  Created by Pole Star on 05/09/2022.
//

import SwiftUI

struct SelectGroupEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @State var selectedRows = Set<String>()
    @State private var selectedRow: String?
    
    @ObservedObject var groupVM: GroupVM
    @ObservedObject var eventVM: EventVM
    
    @StateObject var presentedView: CreateEventRouter
    
    @State var participants: [EventMember] = []
    
    var hasMember: Bool {
        return !self.eventVM.event.members.isEmpty
    }
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SelectGroupEventView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGroupEventView(groupVM: GroupVM(), eventVM: EventVM(), presentedView: CreateEventRouter())
    }
}
