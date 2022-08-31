//
//  PresentedView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import Foundation


class PresentedView: ObservableObject {
    enum AvailableViews {
        case home, signup, about, event, profile
    }
    @Published var currentView: AvailableViews = .signup
}
