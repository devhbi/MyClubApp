//
//  UserDetailScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import SwiftUI

struct UserDetailScreenView: View {
    @Binding var memberVM: MemberVM
    @State var showToast = false
    @EnvironmentObject var accountVM: AccountViewModel
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 128, height: 128)
    
            Text(self.memberVM.member.firstname)
                .font(.system(size: 18, weight: .medium))
            Text(self.memberVM.member.email)
                .font(.footnote)
            Text(self.memberVM.member.role)
                .font(.system(size: 14, weight: .bold))
        }
        .padding()
        
        List {
            Section {
                if self.accountVM.isSuperAdministrator {
                    CheckBoxFieldView(id: "Administrateur", label: "Administrateur", isMarked: self.$memberVM.member.isAdministrator)
                        .listRowSeparator(.hidden)
                    CheckBoxFieldView(id: "Éducateur", label: "Éducateur", isMarked: self.$memberVM.member.isEducator)
                        .listRowSeparator(.hidden)
                }
                else if self.accountVM.isAdministrator {
                    CheckBoxFieldView(id: "Éducateur", label: "Éducateur", isMarked: self.$memberVM.member.isEducator)
                        .listRowSeparator(.hidden)
                    
                }
                CheckBoxFieldView(id: "Membre", label: "Membre", isMarked: self.$memberVM.member.isMember)
                    .listRowSeparator(.hidden)
            }
            
            applyButton
                
        }
        .listStyle(InsetGroupedListStyle())
        .overlay(overlayView: ToastView(toast: Toast(title: "Mis à jour avec succès", image: "checkmark.circle.fill"), show: self.$showToast), show: self.$showToast)
    }
}

extension UserDetailScreenView {
    var applyButton: some View {
        Section {
            Button("Appliquer") {
                withAnimation {
                    self.showToast = self.memberVM.update()
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.system(size: 24, weight: .black, design: .rounded))
            .padding(.vertical, 4)
            .listRowBackground((self.accountVM.isSuperAdministrator || self.accountVM.isAdministrator) ? Color(UIColor.systemBlue) : Color(UIColor.systemBlue).opacity(0.5))
            .buttonStyle(.borderless)
            .foregroundColor(Color(UIColor.systemBackground))
            .disabled(!(self.accountVM.isSuperAdministrator || self.accountVM.isAdministrator))
        }
    }
}




struct UserDetailScreenView_Previews: PreviewProvider {
    @State static var memberVM: MemberVM = MemberVM()
    static var previews: some View {
        UserDetailScreenView(memberVM: $memberVM)
    }
}
