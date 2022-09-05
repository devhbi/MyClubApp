//
//  MyClubAppApp.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 30/08/2022.
//

import SwiftUI
import Firebase

@main
struct MyClubApp: App {
    @StateObject var currentAccount = AccountViewModel.shared
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(LoginSessionController())
                .environmentObject(HomeViewController())
                .environmentObject(SignUpViewController())
                .environmentObject(AccountViewModel())
                .environmentObject(ClubModelController.shared)
        }
    }
}
