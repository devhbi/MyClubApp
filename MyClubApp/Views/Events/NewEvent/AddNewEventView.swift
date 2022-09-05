//
//  AddNewEventView.swift
//  MyClubApp
//
//  Created by Pole Star on 05/09/2022.
//

import SwiftUI

struct AddNewEventView: View {
    @ObservedObject var eventVM: EventVM
    @StateObject var presentedView: CreateEventRouter
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    
//    @State var clubDataModel = ClubModelController.shared
    
    @State private var clubIndex = 0
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct AddNewEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEventView(eventVM: EventVM(), presentedView: CreateEventRouter())
    }
}
