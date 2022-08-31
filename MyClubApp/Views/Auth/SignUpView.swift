//
//  SignUpView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//


import SwiftUI

struct SignInScreenView: View {
    @State private var email: String = "" // by default it's empty
    @State private var password: String = "" // by default it's empty
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 112, height: 112)
                    .clipShape(Circle())
                
                let clubName: String = try! Configuration.value(for:"MY_CLUB_NAME")

                Text(clubName)
                    .font(.title)
                    .bold()
                Spacer().frame(height: 32)
                VStack {
                    HStack{
                        Text("Connectez-vous pour continuer!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("CONTINUER AVEC GOOGLE").foregroundColor(Color("PrimaryColor")))
                    
                    Text("ou avec votre compte")
                        .foregroundColor(Color.black.opacity(0.4))
                    
                    TextField("Adresse email", text: self.$email)
                        .padding(.vertical, 13)
                        .padding(.horizontal)
                        .font(.system(size: 14))
                        .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: -5, y: -5)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
                    
                    SecureField("Mot de passe", text: self.$password)
                        .padding(.vertical, 13)
                        .padding(.horizontal)
                        .font(.system(size: 14))
                        .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: 5, y: 5)
                        .shadow(color: Color(UIColor.label).opacity(0.05), radius: 5, x: -5, y: -5)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
                   
                    HStack {
                        Text("Mot de passe oublié?")
                            .foregroundColor(Color("PrimaryColor"))
                        Spacer()
                        Text("Créer un compte")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.vertical, 12)
                    
                    LoginButton(title: "Je m'identifier")
                    
                }
                
                Spacer()
                Divider()
                Spacer()
                Text("Version 1.0.0")
                    .bold()
                Spacer()
                
            }
            .padding()
        }
    }
}

struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView()
    }
}


struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.system(size: 14, weight: .bold))
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
        .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
    }
}

struct PrimaryButton: View {
    var title: String
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("PrimaryColor"))
            .cornerRadius(8)
    }
}

struct LoginButton: View {
    var title: String
    var body: some View {
        Text(title)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
            .frame(height: 50)
            .foregroundColor(.white)
            .font(.system(size: 18, weight: .bold))
            .background(LinearGradient(colors: [Color.gray, Color.blue], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(5)
    }
}
