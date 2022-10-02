//
//  MyClubAppApp.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 30/08/2022.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct MyClubApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var currentAccount = AccountViewModel.shared
    @StateObject var  authManager = AuthManager.shared
    

    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(authManager)
                .environmentObject(LoginSessionController())
                .environmentObject(HomeViewController())
                .environmentObject(SignUpViewController())
                .environmentObject(AccountViewModel())
                .environmentObject(ClubModelController.shared)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
}
