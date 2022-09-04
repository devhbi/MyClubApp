//
//  CivilRegistryScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI

struct CivilRegistryScreenView: View {
    @EnvironmentObject var presentedSignUpView: SignUpViewController
    
    @StateObject var vm: MemberVM
    var body: some View {
            ZStack (alignment: .topTrailing) {
                GeometryReader { _ in
                    VStack {
                        Text("Créer le compte")
                            .font(.system(size: 32, weight: .heavy))
                        
                        Text("Entrer votre nom complet")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color.gray)
                        
                        VStack(spacing: 18) {
                            EntryTextFieldView(sfSymbolName: "envelope", placeHolder: "Prénom", promptText: self.vm.fistNamePrompt, field: self.$vm.member.firstname)
                            EntryTextFieldView(sfSymbolName: "envelope", placeHolder: "Nom", promptText: self.vm.lastNamePrompt, field: self.$vm.member.lastname)
                            EntryDateFieldView(sfSymbolName: "calendar", placeHolder: "Date naissance", promptText: self.vm.birthDatePrompt, field: self.$vm.member.birthDate)
                        }
                        .padding(.vertical, 16)
                        Button(action: {
                            // print("Créer le compte avec un mail")
                            withAnimation {
                                self.presentedSignUpView.currentPage = .address
                            }
                        }, label: {
                            Text("CONTINUER")
                                .foregroundColor(.white)
                                .font(.system(size: 18, weight: .bold))
                        })
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .background(LinearGradient(colors: [Color.gray, Color.blue], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(5)
                        Spacer()
                    }.padding(.horizontal, 32)
                }

            }
    }
}

struct AddressSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CivilRegistryScreenView(vm: MemberVM())
    }
}
