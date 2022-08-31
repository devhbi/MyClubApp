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
    @EnvironmentObject var presentedView: PresentedView
    var body: some View {
        
        ZStack (alignment: .leading) {
            RightViewContainer
            LeftViewContainer
        }
         
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
                    Text("Accueil")
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding()
                .foregroundColor(.primary)
                .overlay(Rectangle().stroke(Color.primary.opacity(0.1), lineWidth: 1).shadow(radius: 3).edgesIgnoringSafeArea(.top))
                
                // Right view
                
                switch presentedView.currentView {
                    case .home:
                        let clubUrl: String = try! Configuration.value(for:"MY_CLUB_WEB_URL")
                        HomeWebView(url: URL(string: clubUrl)!)
                    case .signup:
                        SignUpView()
                }
                //

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
