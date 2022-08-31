//
//  PresentedView.swift
//  MyClubApp
//
//  Created by Pole Star on 31/08/2022.
//

import Foundation


class PresentedView: ObservableObject {
    enum AvailableViews {
        case home, signup
    }
    @Published var currentView: AvailableViews = .home
}
