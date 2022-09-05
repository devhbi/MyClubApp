//
//  CreateEventRouter.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 05/09/2022.
//

import Foundation

class CreateEventRouter: ObservableObject {
    enum AvailableViews {
        case action, group, form
    }
    
    @Published var currentView: AvailableViews = .action
}
