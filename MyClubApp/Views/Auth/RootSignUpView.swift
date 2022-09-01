//
//  RootSignUpView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI

struct RootSignUpView: View {
    @EnvironmentObject var presentedSignUpView: SignUpViewController
    
    @StateObject var userViewModel = CreateNewUserViewModel()
    
    var body: some View {
        switch self.presentedSignUpView.currentPage {
            case .email:
                EmailSignUpView(vm: self.userViewModel)
            case .civil:
                CivilRegistryScreenView(vm: self.userViewModel)
            case .address:
                AddressRegistryScreenView(vm:  self.userViewModel)
            case .created:
                let clubUrl: String = try! Configuration.value(for:"MY_CLUB_WEB_URL")
                HomeWebView(url: URL(string: clubUrl)!)
        }
    }
}

struct RootSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        RootSignUpView()
    }
}
