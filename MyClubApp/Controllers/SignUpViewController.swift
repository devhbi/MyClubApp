//
//  SignUpViewController.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import Foundation


class SignUpViewController: ObservableObject {
    enum Page {
        case email
        case civil
        case address
        case created
    }
    
    @Published var currentPage: Page = .email
    
}
