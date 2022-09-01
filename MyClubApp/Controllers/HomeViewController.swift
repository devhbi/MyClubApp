//
//  HomeViewController.swift
//  HomeViewController
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import Foundation


class HomeViewController: ObservableObject {
    enum AvailableViews {
        case home, signup, login, about, event, profile
    }
    @Published var currentView: AvailableViews = .signup
}
