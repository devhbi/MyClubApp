//
//  AddNewGroupView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import SwiftUI

struct AddNewGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var profileVM: AccountViewModel
    @StateObject var vm = GroupVM()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Form(content: {
                    general
                    description
                    button
                })
                .background(.green)
                .onTapGesture {
                    hideKeyboard()
                }
            }
            .navigationBarTitle(Text("Créer le groupe"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        handleDismissal()
                    }
                }
            }
        }
    }
}

struct AddNewGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewGroupView()
    }
}

private extension AddNewGroupView {
    var general: some View {
        Section {
            TextField("Nom", text: self.$vm.group.name)
                .textContentType(.name)
        }
        header:{
            Text("")
        }
    }
    
    var description: some View {
        Section {
            
            Picker("Audiance", selection: self.$vm.group.audiance) {
                ForEach(Event.Audiance.allCases) { destAudiance in
                    Text(destAudiance.rawValue.capitalized).tag(destAudiance)
                }
            }
            
            Picker("Visibility", selection: self.$vm.group.visibility) {
                ForEach(GroupModel.Visibility.allCases) { visibility in
                    Text(visibility.rawValue.capitalized).tag(visibility)
                }
            }
        }
        header:{
            Text("Descriptions")
        }
    }
    
    var button: some View {
        Section {
            Button("CRÉER") {
                let member = GroupMember(uid: profileVM.uid, firstname: profileVM.firstname, lastname: profileVM.lastname, birthdate: profileVM.birthDate, role: EventMember.Role.administrator)
                self.vm.group.members[profileVM.uid] = member
                self.vm.save()
                handleDismissal()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .black, design: .rounded))
            .padding(.vertical, 4)
            .listRowBackground(self.vm.isValide ? Color(UIColor.systemBlue) : Color(UIColor.systemBlue).opacity(0.5))
            .buttonStyle(.borderless)
            .foregroundColor(Color(UIColor.systemBackground))
            .disabled(!self.vm.isValide)
        }
    }
}
private extension AddNewGroupView {
    func handleDismissal() {
        if #available(iOS 15.0, *) {
            dismiss()
        }
        else {
            presentationMode.wrappedValue.dismiss()
        }
        
    }
}
