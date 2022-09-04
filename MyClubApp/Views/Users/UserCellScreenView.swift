//
//  UserCellScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import SwiftUI


struct UserCellScreenView: View {
    @State var memberVM: MemberVM
    
    @Binding var selectedItems: Set<String>
    
    var isSelected: Bool {
        selectedItems.contains(self.memberVM.member.id)
    }
    
    
    var body: some View {
        NavigationLink (destination: UserDetailScreenView(memberVM: self.$memberVM)){
            
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color(.systemBlue))
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(self.memberVM.member.fullname) // 3
                    Text(self.memberVM.member.role) // 4
                        .font(.footnote)
                }
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                if self.isSelected {
                    self.selectedItems.remove(self.memberVM.member.id)
                }
                else {
                    self.selectedItems.insert(self.memberVM.member.id)
                }
            }
        }
    }
}
struct UserCellScreenView_Previews: PreviewProvider {
    @State static var memberVM: MemberVM = MemberVM()
    @State static var selectedItems: Set<String> = Set<String>()
    static var previews: some View {
        UserCellScreenView(memberVM: memberVM, selectedItems: $selectedItems)
    }
}
