//
//  MyClubAppApp.swift
//  MyClubApp
//
//  Created by Pole Star on 30/08/2022.
//

import SwiftUI

@main
struct MyClubApp: App {
    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(PresentedView())
        }
    }
}
