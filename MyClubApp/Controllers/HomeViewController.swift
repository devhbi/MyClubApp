//
//  HomeViewController.swift
//  HomeViewController
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import Foundation


class HomeViewController: ObservableObject {
    enum AvailableViews {
        case home, account, login, about, event, users, signup
    }
    @Published var currentView: AvailableViews = .login
}
