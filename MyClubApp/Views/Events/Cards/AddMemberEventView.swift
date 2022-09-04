//
//  AddMemberEventView.swift
//  MyClubApp
//
//  Created by Pole Star on 04/09/2022.
//

import SwiftUI

struct AddMemberEventView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @Binding var eventVM: EventVM
    @State var evtMemberVM: EventMemberVM = EventMemberVM()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Form(content: {
                    general
                    matchs
                    button
                })
                .background(.blue)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationBarTitle(Text("\(self.eventVM.event.name)"))
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
                        handleDismissal()
                    }
                }
            }
        }
    }
}

private extension AddMemberEventView {
    func handleDismissal() {
        if #available(iOS 15.0, *) {
            dismiss()
        }
        else {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}

private extension AddMemberEventView {
    var general: some View {
        Section {
            TextField("Nom", text: self.$evtMemberVM.member.lastname)
                .textContentType(.name)
            
            TextField("Prénom", text: self.$evtMemberVM.member.firstname)
                .textContentType(.name)
            
            Picker("Rôle", selection: self.$evtMemberVM.member.role) {
                ForEach(EventMember.Role.allCases) { role in
                    Text(role.rawValue.capitalized).tag(role)
                }
            }
        }
        header:{
            Text("Nouveau membre")
        }
    }
    
    
    var matchs: some View {
        Section {
            Toggle(isOn: self.$evtMemberVM.member.accepted) {
                Text("Accepté")
            }
            
            Toggle(isOn: self.$evtMemberVM.member.refused) {
                Text("Réfusé")
            }
            
            Toggle(isOn: self.$evtMemberVM.member.inwaiting) {
                Text("En attente")
            }
        }
        header:{
            Text("Status")
        }
    }
    
    var button: some View {
        Section {
            Button("AJOUTER") {
                self.eventVM.event.members.append(self.evtMemberVM.member)
                self.eventVM.update()
                handleDismissal()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .black, design: .rounded))
            .padding(.vertical, 4)
            .listRowBackground(self.evtMemberVM.isValid ? Color(UIColor.systemBlue) : Color(UIColor.systemBlue).opacity(0.5))
            .buttonStyle(.borderless)
            .foregroundColor(Color(UIColor.systemBackground))
            .disabled(!self.evtMemberVM.isValid)
        }
    }
}

struct AddMemberEventView_Previews: PreviewProvider {
    @State static var eventVM: EventVM = EventVM()
    static var previews: some View {
        AddMemberEventView(eventVM: $eventVM)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
