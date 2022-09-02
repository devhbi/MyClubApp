//
//  HomeViewController.swift
//  HomeViewController
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import Foundation


class HomeViewController: ObservableObject {
    enum AvailableViews {
        case home, login, about, event, profile, users, signup
    }
    @Published var currentView: AvailableViews = .login
}
