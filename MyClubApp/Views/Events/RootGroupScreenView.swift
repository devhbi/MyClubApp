//
//  RootGroupScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import SwiftUI


struct RootGroupScreenView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var numberOfRows = 2
    let spacing: CGFloat = 32
    
    @State var showAddGroupSheetView = false
    @ObservedObject var vm = GroupListVM()
    @EnvironmentObject var profileVM: AccountViewModel

    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(),  spacing: spacing), count: self.numberOfRows)
        ZStack(alignment: .bottom) {
            ScrollView {
                HStack {
                    Text(self.profileVM.initials).bold()
                           .foregroundColor(.white)
                           .padding(12)
                           .background(Color.gray)
                           .mask(Circle())
                           .frame(width: 56, height: 56)
                    Text("Groupe")
                        .font(.system(size: 18, weight: .black, design: .rounded))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                .padding(.horizontal)
                

                
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(self.vm.groupListVM, id: \.self) { model in
                        GroupCardButton(vm: vm, groupVM: model)
                    }
                }
                .padding(.all, 10)
                .onAppear(perform: vm.load)
                
            }
            
            if (!self.profileVM.isMember) {
                AddGroupButton
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: self.$showAddGroupSheetView, onDismiss: {
            withAnimation {
                vm.load()
            }
        }, content: {
            AddNewGroupView()
        })
    }
}

private extension RootGroupScreenView {
    var AddGroupButton: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showAddGroupSheetView.toggle()
                    }
                }, label: {
                    Text("+")
                        .font(.system(.largeTitle))
                        .frame(width: 64, height: 56)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 8)
                })
                .background(Color.blue)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
            }
        }
    }
}

struct GroupCardButton:View {
    @State private var isPresented = false
    @ObservedObject var vm: GroupListVM
    let groupVM: GroupVM
    
    var body: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            GroupItemCardView(vm: groupVM)
        })
        .fullScreenCover(isPresented: self.$isPresented, onDismiss: {
            withAnimation {
                vm.load()
            }
        }, content: {
            GroupDetailView(groupVM: groupVM)
        })
        .buttonStyle(ItemButtonStyle(cornerRadius: 16))
    }
}

struct RootGroupScreenView_Previews: PreviewProvider {
    static var previews: some View {
        RootGroupScreenView()
    }
}
