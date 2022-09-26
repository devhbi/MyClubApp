//
//  MenuContent.swift
//  MyClub
//
//  Created by Honoré BIZAGWIRA on 30/08/2022.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var presentedView: HomeViewController
    @EnvironmentObject var authSession: LoginSessionController
    @EnvironmentObject var accountVM: AccountViewModel
    @Binding var dark:Bool
    @Binding var show:Bool
    var body: some View {
        VStack {
            HeaderBar
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            let clubName: String = try! Configuration.value(for:"MY_CLUB_NAME")
            VStack(spacing: 12) {
                Text(clubName)
                    .font(.title2.bold())
            }
            .padding(.top, 25)
            
            
//            DisplayModeBar
            
            Group {

                HomeMenuSection
                    .disabled(self.authSession.currentLoginState != .login)
                    .opacity(self.authSession.currentLoginState != .login ? 0.5 : 1)
                
                AccountMenuSection
                
                UserMenuSection
                    .disabled(self.authSession.currentLoginState != .login)
                    .opacity(self.authSession.currentLoginState != .login ? 0 : 1)
                
                Spacer()
                
                AboutMenuSection
                    //.disabled(self.authSession.currentLoginState != .login)
                    //.opacity(self.authSession.currentLoginState != .login ? 0.5 : 1)
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width/1.5)
        .background((self.dark ? Color.black: Color.white).edgesIgnoringSafeArea(.all))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
    }
}

extension MenuView  {

    var HeaderBar: some View {
        HStack {
            Button (action: {
                withAnimation(.default) {
                    self.show.toggle()
                }
            }, label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .frame(width: 12, height: 20)
            })
            
            Spacer()
            
            /*
            Button (action: {
                
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.title)
            }
            */
        }
        .padding(.top)
        .padding(.bottom, 25)
    }
}

extension MenuView  {

    var DisplayModeBar: some View {
        HStack (spacing: 18) {
            Image(systemName: "moon.fill")
                .font(.title)
            
            Text("Mode sombre")
                .font(.system(size: 14, weight: .semibold))
            
            Spacer()
            
            Button(action: {
                self.dark.toggle()
                
                UIWindow.appearance().overrideUserInterfaceStyle = self.dark ? .dark : .light
            },label: {
                Image(systemName: "switch.2")
                    .font(.title)
                    .rotationEffect(.init(degrees: self.dark ? 180 : 0))
            })
        }
        .padding(.top, 16)
    }
}



extension MenuView  {

    var HomeMenuSection: some View {
        VStack {
            Divider()
                .padding(.top, 8)
            Button(action: {
                withAnimation(.default) {
                    self.presentedView.currentView = .home
                    self.show.toggle()
                }
            }){
                HStack(spacing: 22) {
                    Image(systemName: "house")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text("Accueil")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
            }
            .padding(.top, 8)
            
            Button(action: {
                withAnimation(.default) {
                    self.presentedView.currentView = .event
                    self.show.toggle()
                }
            }){
                HStack(spacing: 22) {
                    Image(systemName: "calendar")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    Text("Événements")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
            }
            .padding(.top, 8)
        }
    }
}

extension MenuView  {

    var AccountMenuSection: some View {
        VStack {
            Divider()
                .padding(.top, 8)
            Text("Profil")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding()
                .padding(.leading)
                .padding(.vertical, -18)
            
            if self.authSession.currentLoginState != .login {
                Button(action: {
                    withAnimation(.default) {
                        self.presentedView.currentView = .login
                        self.show.toggle()
                    }
                }){
                    HStack(spacing: 22) {
                        Image(systemName: "lock.open")                    .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Connexion")
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                }
            }
            else {
                Button(action: {
                    withAnimation(.default) {
                        self.presentedView.currentView = .account
                        self.show.toggle()
                    }
                }){
                    HStack(spacing: 22) {
                        Image(systemName: "person.circle")                    .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Mon compte")
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                }
                .disabled(self.authSession.currentLoginState != .login)
                .opacity(self.authSession.currentLoginState != .login ? 0.5 : 1)
                .padding(.top, 8)
                
                Button(action: {
                    withAnimation(.default) {
                        self.authSession.signOutUser()
                        self.show.toggle()
                        self.presentedView.currentView = .login
                        self.authSession.currentLoginState = .none
                    }
                }){
                    HStack(spacing: 22) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")  .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Déconnexion")
                            .font(.system(size: 14, weight: .semibold))
                        Spacer()
                    }
                }
                .disabled(self.authSession.currentLoginState != .login)
                .opacity(self.authSession.currentLoginState != .login ? 0.5 : 1)
                .padding(.top, 8)
            }
        }
    }
}

extension MenuView  {

    var UserMenuSection: some View {
        VStack {
            Divider()
                .padding(.top, 8)
            Text("Gestion")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding()
                .padding(.leading)
                .padding(.vertical, -18)
            
            Button(action: {
                withAnimation(.default) {
                    self.presentedView.currentView = .users
                    self.show.toggle()
                }
            }){
                HStack(spacing: 22) {
                    if self.accountVM.isSuperAdministrator {
                        Image(systemName: "laptopcomputer")                    .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Administrateur")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    else if accountVM.isAdministrator {
                        Image(systemName: "person.2.circle")                    .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Responsable")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    else if accountVM.isEducator {
                        Image(systemName: "person.2.circle")                    .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                        Text("Éducateur")
                            .font(.system(size: 14, weight: .semibold))
                    }
                        
                    Spacer()
                }
            }
        }
    }
}


extension MenuView  {

    var AboutMenuSection: some View {
        VStack {
            Divider()
                .padding(.top, 8)
            Text("Plus")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding()
                .padding(.leading)
                .padding(.vertical, -18)
            Button(action: {
                withAnimation(.default) {
                    self.presentedView.currentView = .about
                    self.show.toggle()
                }
            }){
                HStack(spacing: 22) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                    Text("À propos")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                }
            }
            .padding(.top, 8)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    @State static var dark: Bool = true
    @State static var show: Bool = true
    static var previews: some View {
        MenuView(dark: $dark, show: $show)
    }
}

