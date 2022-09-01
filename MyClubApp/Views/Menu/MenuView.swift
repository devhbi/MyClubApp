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
    @Binding var dark:Bool
    @Binding var show:Bool
    var body: some View {
        VStack {
            //MenuHeaderButton
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
            
            Divider()
                .padding(.top, 16)
            
            DisplayModeBar
            
            Group {

                HomeBarItem
                
                EventBarItem
                
                Divider()
                    .padding(.top, 16)
                
                Text("Profil")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding()
                    .padding(.leading)
                    .padding(.vertical, -18)
                AccountBarItem
                
                LogOutBarItem
                
                Spacer()
                Divider()
                    .padding(.top, 16)
                Text("Plus")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .padding()
                    .padding(.leading)
                    .padding(.vertical, -18)
                AboutBarItem
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

    var HomeBarItem: some View {
        Button(action: {
            withAnimation(.default) {
                self.presentedView.currentView = .home
            }
        }){
            HStack(spacing: 22) {
                Image(systemName: "house")
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("Accueil")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}

extension MenuView  {

    var EventBarItem: some View {
        Button(action: {
            withAnimation(.default) {
                self.presentedView.currentView = .event
            }
        }){
            HStack(spacing: 22) {
                Image(systemName: "calendar")
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("Événements")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}

extension MenuView  {

    var AccountBarItem: some View {
        Button(action: {
            withAnimation(.default) {
                self.presentedView.currentView = .login
            }
        }){
            HStack(spacing: 22) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("Mon compte")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}

extension MenuView  {

    var LogOutBarItem: some View {
        Button(action: {
            withAnimation(.default) {
                self.presentedView.currentView = .home
            }
        }){
            HStack(spacing: 22) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .frame(width: 22, height: 22)
                Text("Déconnexion")
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
        }
        .padding(.top, 16)
    }
}

extension MenuView  {

    var AboutBarItem: some View {
        Button(action: {
            withAnimation(.default) {
                self.presentedView.currentView = .about
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
        .padding(.top, 16)
    }
}
/*
struct MenuContent_Previews: PreviewProvider {
    static var previews: some View {
        MenuContent(dark: false, show: false)
    }
}
*/

