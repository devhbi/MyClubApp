//
//  UserListScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 02/09/2022.
//

import SwiftUI

struct UserListScreenView: View {
    @ObservedObject var vm = MemberListVM()
    @State var selectedRows = Set<String>()
    @State var isInviting = false
    @State var searchText: String = ""
    @EnvironmentObject var accountVM: AccountViewModel
    
    var searchedResults: [MemberVM] {
        
        var memberVMs: [MemberVM] = [MemberVM]()
        if self.accountVM.isSuperAdministrator {
            memberVMs = vm.memberVMs.filter {$0.member.isAdministrator || $0.member.isEducator  || $0.member.isMember}
        }
        else if self.accountVM.isAdministrator {
            memberVMs = vm.memberVMs.filter {$0.member.isEducator || $0.member.isMember}
        }
        else if self.accountVM.isEducator {
            memberVMs = vm.memberVMs.filter {$0.member.isMember}
        }
        
        if searchText.isEmpty {
            return memberVMs
        }
        else {
            return memberVMs.filter {
                $0.member.firstname.contains(searchText) || $0.member.lastname.contains(searchText) || $0.member.email.contains(searchText)
            }
        }
    }
    
    var body: some View {
        GeometryReader {bounds in
            ZStack {
                List(selection: $selectedRows) {
                    ForEach(searchedResults) { userDataModel in
                        UserCellScreenView(memberVM: userDataModel, selectedItems: $selectedRows)

                    }
                    .onDelete(perform: { indexSet in
                        self.vm.memberVMs.remove(atOffsets: indexSet)
                    })
                    .onMove(perform: { indeces, newOffset in
                        self.vm.memberVMs.move(fromOffsets: indeces, toOffset: newOffset)
                    })
                    
                    Spacer()
                }
                .id(UUID().uuidString)
                .onAppear (perform: vm.load)
                .navigationTitle("Membres")

            }
            .searchable(text: $searchText)
            .listStyle(.inset)
            .environment(\.editMode, .constant(self.isInviting ? .active : .inactive))
            .animation(.spring(), value: self.isInviting)
        }
    }
}

struct UserListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        UserListScreenView()
    }
}
