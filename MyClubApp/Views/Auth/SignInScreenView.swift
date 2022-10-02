//
//  SignInScreenView.swift
//  MyClubApp
//  
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//


import SwiftUI

struct SignInScreenView: View {
    @EnvironmentObject var presentedView: HomeViewController
    @EnvironmentObject var authSession: LoginSessionController
    @EnvironmentObject var authManager: AuthManager
    @StateObject var memberVM: MemberVM
    @State private var isPresentedResetUserAlert = false
    
    var body: some View {
        ZStack {
//            Color("BgColor").edgesIgnoringSafeArea(.all)
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
                Spacer().frame(height: 16)
                VStack {
                    HStack{
                        Text("Connectez-vous pour continuer!")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.gray)
                        Spacer()
                    }
                    
                    
                    EntryTextFieldView(sfSymbolName: "envelope", placeHolder: "Email address", promptText: self.memberVM.emailPrompt, field: self.$memberVM.member.email)
                        .onAppear {self.memberVM.member.email = "hbi.test@gmail.com"}
                    EntryTextFieldView(sfSymbolName: "key", placeHolder: "Password", promptText: "", isSecure: true, field: self.$memberVM.member.password)
                        .onAppear {self.memberVM.member.password = "hbixDev0"}
                   
                    HStack {
                        Button(action: {
                            print("Mot de passe oublié pressed")
                            withAnimation(.default) {
                                self.isPresentedResetUserAlert = true
                            }
                        }){
                            Text("Mot de passe oublié?")
                                .foregroundColor(Color("PrimaryColor"))
                        }
                        .alert(isPresented: self.$isPresentedResetUserAlert) { () -> Alert in
                            Alert(title: Text("Mot de passe oublié"), message: Text("Voulez-vous réinitialiser votre mot de passe?"), primaryButton: .default(Text("Oui"), action: {
                                print("Oui")
                            }), secondaryButton: .default(Text("Annuler")))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            print("Créer un compte pressed")
                            withAnimation(.default) {
                                self.presentedView.currentView = .signup
                            }
                        }){
                            Text("Créer un compte")
                                .foregroundColor(Color("PrimaryColor"))
                        }
                    }
                    //.padding(.vertical, 12)
                    
                    LoginButton
                    
                    Text("ou avec votre compte")
                        .foregroundColor(Color.black.opacity(0.4))
                    
                    Button(action: {
                        print("CONTINUER AVEC GOOGLE pressed")
                        
                        self.authManager.login(with: .signInWitGoogle)
                    }, label: {
                        
                    })
                    .buttonStyle(SampleStyle(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("CONTINUER AVEC GOOGLE")))
                    
                    
                    Button(action: {
                        print("CONTINUER AVEC APPLE pressed")
                        self.authManager.login(with: .signInWithApple)
                    }, label: {
                        
                    })
                    .buttonStyle(SampleStyle(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("CONTINUER AVEC APPLE")))
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
        SignInScreenView(memberVM : MemberVM())
    }
}


struct SocalLoginButton: View {
    var image: Image
    var text: Text
    //let action: () -> Void
    var body: some View {
        
        Button(action: {
            //action()
        }) {
            HStack {
                image
                    .padding(.horizontal)
                Spacer()
                text
                    .font(.system(size: 14, weight: .bold))
                Spacer()
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 48)
    //        .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
            .overlay(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.label), lineWidth: 1))
        }
    }
}

struct SampleStyle: ButtonStyle {
    var image: Image
    var text: Text
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            image
                .padding(.horizontal)
            Spacer()
            text
                .font(.system(size: 14, weight: .bold))
            Spacer()
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 48)
//        .background(Color.white)
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

extension SignInScreenView  {
    var LoginButton : some View {
        Button(action: {
            authSession.signIn(email: self.memberVM.member.email, password: self.memberVM.member.password){(result, error) in
                if let error = error {
                    print("Failed \(error.localizedDescription)")
                }
                else {
                    self.presentedView.currentView = .home
                    self.authSession.currentLoginState = .login
                }
            }
        }) {
            Text("JE M'IDENTIFIE!")
                .font(.system(size: 18, weight: .bold))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 48)
        //.frame(height: 50)
        .foregroundColor(.white)
        .background(LinearGradient(colors: [Color.gray, Color.blue], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(5)
    }
}
