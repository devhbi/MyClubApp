//
//  CompleteRegisterScreenView.swift
//  MyClubApp
//
//  Created by Pole Star on 01/09/2022.
//

import SwiftUI

struct AddressRegistryScreenView: View {
    @EnvironmentObject var presentedSignUpView: SignUpViewController
    @EnvironmentObject var presentedView: HomeViewController
    
    @StateObject var vm: CreateNewUserViewModel
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            GeometryReader { _ in
                VStack {
                    Text("Créer le compte")
                        .font(.system(size: 32, weight: .heavy))
                    
                    
                    Text("Quelle est votre adresse")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    VStack(spacing: 18) {
                        
                        TextField ("Rue", text: self.$vm.member.street)
                            .font(.system(size: 14))
                            .padding(12)
                            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
                            .autocapitalization(.none)
                        
                        EntryTextFieldView(sfSymbolName: "archivebox", placeHolder: "Code postale", promptText: self.vm.postalCodePrompt, field: self.$vm.member.zipcode)
                        
                        TextField ("Ville", text: self.$vm.member.city)
                            .font(.system(size: 14))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
                            .autocapitalization(.none)
                        
                        EntryTextFieldView(sfSymbolName: "phone", placeHolder: "Phone", promptText: self.vm.phonePrompt, field: self.$vm.member.phone)
                        
                      
                    }
                    .padding(.vertical, 16)
                    Button(action: {
                        print("Créer le compte avec un mail")
                        withAnimation {
                            self.presentedView.currentView = .home
                            
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

struct CompleteRegisterScreenView_Previews: PreviewProvider {
    static var previews: some View {
        AddressRegistryScreenView(vm: CreateNewUserViewModel())
    }
}
