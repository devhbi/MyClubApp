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
    
    @State var clubDataModel = ClubModelController.shared
    
    @State private var clubIndex = 0
    var body: some View {
        NavigationView {
            
            VStack {
                List {
                    names
                    description
                    dates
                    general
                    visibility
                    button
                }
                .background(.purple)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationBarTitle(Text("Créer l'événement"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        self.eventVM.save()
                        handleDismissal()
                    }
                    .disabled(!self.eventVM.isValid)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        self.presentedView.currentView = .action
                        handleDismissal()
                    }
                }
            }
        }
    }
}



private extension AddNewEventView {
    var names: some View {
        Section {
            TextField("Nom", text: self.$eventVM.event.name)
                .textContentType(.name)
            
            TextField("Lieu", text: self.$eventVM.event.lieu)
                .textContentType(.addressState)
            
            HStack {
                Text("Équipe")
                Spacer()
                Text(self.eventVM.event.group)
            }
                                
        }
    }
    
    var description: some View {
        Section {
            TextEditor(text: self.$eventVM.event.description)
        }
        header:{
            Text("Description")
        }
    }
    
    var dates: some View {
        Section {
            
            DatePicker("Début ",
                selection: self.$eventVM.event.startDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            DatePicker("Fin ",
                selection: self.$eventVM.event.endDate,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
        header:{
            Text("Dates")
        }
//        footer:{
//            Text("Veillez ajouter la date du début et la fin de l'événement")
//        }
    }
    
    var general: some View {
        Section {
            
            Picker("Type d'événement", selection: self.$eventVM.event.type) {
                ForEach(Event.EventType.allCases) { eventtype in
                    Text(eventtype.rawValue.capitalized).tag(eventtype)
                }
            }
            
            Picker("Type de match", selection: self.$eventVM.event.typeMatch) {
                ForEach(Event.MatchType.allCases) { matchType in
                    Text(matchType.rawValue.capitalized).tag(matchType)
                }
            }
            
            Picker(selection: self.$clubIndex, label: Text("Adversaire")) { //clubIndex self.$vm.newEventModel.opposingTeam
//                SearchBar(text: self.$vm.newEventModel.opposingTeam, placeholder: "Trouver le club")
                pickerContent()
            }
            
            TextField("Installation", text: self.$eventVM.event.installation)
                .textContentType(.name)
        }
        header:{
            Text("Événement")
        }
    }
    
    @ViewBuilder
    func pickerContent() -> some View {
        ForEach(0 ..< self.clubDataModel.clubs.count, id:\.self) {
            Text(self.clubDataModel.clubs[$0])
                .tag([$0])
                .frame(height: 64)
        }
        .id(UUID())
        .pickerStyle(SegmentedPickerStyle())
//        .onReceive([self.clubIndex].publisher.first()) { (value) in
//            self.vm.newEventModel.opposingTeam = self.clubDataModel.clubs[value]
//            print("################ \(value) \(self.vm.newEventModel.opposingTeam)")
//        }
        
    }
    
    var visibility: some View {
        Section {
            Picker("Type de match", selection: self.$eventVM.event.visibility) {
                ForEach(Event.Visibility.allCases) { visibility in
                    Text(visibility.rawValue.capitalized).tag(visibility)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        header:{
            Text("Visibilité de l'événement")
        }
    }
    
    var button: some View {
        Section {
            Button("CRÉER") {
                print("######## Size: \(self.eventVM.event.members.count)")
                if !self.clubDataModel.clubs.isEmpty {
                    self.eventVM.event.opposingTeam = self.clubDataModel.clubs[0]
                }
                self.eventVM.save()
                handleDismissal()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .black, design: .rounded))
            .padding(.vertical, 4)
            .listRowBackground(self.eventVM.isValid ? Color(UIColor.systemBlue) : Color(UIColor.systemBlue).opacity(0.5))
            .buttonStyle(.borderless)
            .foregroundColor(Color(UIColor.systemBackground))
            .disabled(!self.eventVM.isValid)
        }
    }
}

private extension AddNewEventView {
    func handleDismissal() {
        if #available(iOS 15.0, *) {
            dismiss()
        }
        else {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}


struct AddNewEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEventView(eventVM: EventVM(), presentedView: CreateEventRouter())
    }
}
