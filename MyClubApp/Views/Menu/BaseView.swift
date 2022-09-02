//
//  MenuView.swift
//  MyClub
//
//  Created by Honoré BIZAGWIRA on 29/08/2022.
//

import SwiftUI

struct BaseView: View {
    @State var dark = false
    @State var show = false
    @EnvironmentObject var presentedView: HomeViewController
    @EnvironmentObject var presentedSignUpView: SignUpViewController
    @EnvironmentObject var authSession: LoginSessionController
    @StateObject var userVM = CreateNewUserViewModel()
    
    var body: some View {
        
        ZStack (alignment: .leading) {
            RightViewContainer
            LeftViewContainer
        }
        .onAppear(perform: getUserSession)
    }
    
    func getUserSession() {
        self.authSession.loginListen()
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}

extension BaseView  {
    var RightViewContainer: some View {
        
        GeometryReader {_ in
            VStack {
                TopViewContainer
                // Right view
                BodyViewContainer
            }
        }
    }
}

extension BaseView  {
    var TopViewContainer: some View {
        ZStack {
            HStack {
                Button(action: {
                    withAnimation(.default) {
                        self.show.toggle()
                    }
                }) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title)
                }
                Spacer()
            }
            
            if self.authSession.currentLoginState == .login {
                switch presentedView.currentView {
                    case .home:
                        Text("Accueil")
                            .font(.system(size: 16, weight: .semibold))
                    case .login:
                        Text("Connexion")
                            .font(.system(size: 16, weight: .semibold))
                    case .about:
                        Text("Accueil")
                            .font(.system(size: 16, weight: .semibold))
                    case .event:
                        Text("Événements")
                            .font(.system(size: 16, weight: .semibold))
                    case .account:
                        Text("Compte")
                            .font(.system(size: 16, weight: .semibold))
                    case .users:
                        Text("Membres")
                            .font(.system(size: 16, weight: .semibold))
                    case .signup:
                        Text("Créer un compte")
                            .font(.system(size: 16, weight: .semibold))
                }
            }
            else {
                Text(presentedView.currentView == .login ? "Connexion" : "Créer un compte")
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding()
        .foregroundColor(.primary)
        .overlay(Rectangle().stroke(Color.primary.opacity(0.1), lineWidth: 1).shadow(radius: 3).edgesIgnoringSafeArea(.top))
    }
}

extension BaseView  {
    var BodyViewContainer: some View {
        VStack {
            if self.authSession.currentLoginState == .login {
                switch presentedView.currentView {
                    case .home:
                        let clubUrl: String = try! Configuration.value(for:"MY_CLUB_WEB_URL")
                        HomeWebView(url: URL(string: clubUrl)!)
                    case .login:
                    SignInScreenView(userVM: self.userVM)
                    case .about:
                        AboutView()
                    case .event:
                        EventScreenView()
                    case .account:
                        AccountScreenView()
                    case .users:
                        UserListScreenView()
                    case .signup:
                        RootSignUpView()
                }
            }
            else {
                if presentedView.currentView == .login {
                    SignInScreenView(userVM: self.userVM)
                }
                else {
                    RootSignUpView()
                }
            }
        }
    }
}
extension BaseView  {

    var LeftViewContainer: some View {
        HStack {
            MenuView(dark: self.$dark, show: self.$show)
                .preferredColorScheme(self.dark ? .dark : .light)
                .offset(x: self.show ? 0 : -UIScreen.main.bounds.width/1.5)
            Spacer(minLength: 0)
        }
        .background(Color.primary.opacity(self.show ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(.all))
    }
}
