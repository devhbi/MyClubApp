//
//  EmailSignUpView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI

struct EmailSignUpView: View {
    @EnvironmentObject var presentedSignUpView: SignUpViewController
    
    @StateObject var vm : CreateNewUserViewModel
    
    var body: some View {
        ZStack (alignment: .topTrailing) {
            GeometryReader { _ in
                VStack {
                    Text("Créer un compte")
                        .font(.system(size: 32, weight: .heavy))
                     
                    Text("Entrer votre email!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.gray)
                    
                    VStack(spacing: 18) {
                        EntryTextFieldView(sfSymbolName: "envelope", placeHolder: "Mail", promptText: self.vm.emailPrompt, field: self.$vm.newUserModel.email)
                        EntryTextFieldView(sfSymbolName: "key", placeHolder: "Mot de passe", promptText: self.vm.passwordPrompt, isSecure: true, field: self.$vm.newUserModel.password)
                        EntryTextFieldView(sfSymbolName: "key", placeHolder: "Mot de passe", promptText: self.vm.confirmPwPrompt, isSecure: true, field: self.$vm.newUserModel.repassword)
                        
                    }
                    .padding(.vertical, 16)
                    
                    Button(action: {
                        // print("Créer le compte avec un mail")
                        withAnimation {
                            self.presentedSignUpView.currentPage = .civil
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
                }
                .padding(.horizontal, 32)
            }
        }
    }
}
