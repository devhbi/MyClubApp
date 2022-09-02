//
//  AccountScreenView.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 31/08/2022.
//

import SwiftUI


struct AccountScreenView: View {
    @State private var isLoading = false
    @EnvironmentObject var accountVM: AccountViewModel
    @State var activationCode: String = ""
    
    var body: some View {
        AccountItemsView
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountScreenView()
    }
}

extension AccountScreenView{
    var AccountItemsView: some View {
        VStack {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())

                Text(self.accountVM.fullname)
                    .font(.title)
                    .bold()
            }
            
            List {
                Section(header: Text("Personal Information")){
                    AccountItemRowView(name: "Prénom", value: self.accountVM.firstname)
                    AccountItemRowView(name: "Nom", value: self.accountVM.lastname)
                    AccountItemRowView(name: "Email", value: self.accountVM.email)
                    AccountItemRowView(name: "Date de naissance", value: self.accountVM.birthDate)
                    Button {
                        inputTextDialog(title: "Role", message: "Veillez entrer le code d'activation reçu!", hintText: "Code d'activation", primaryTitle: "Envoyer", secondaryTitle: "Annuler")
                        { text in
                            self.activationCode = text
                            print(text)
                        } secondaryAction: {
                            print("L'activation annulée!")
                        }
                    }
                    label:{
                        AccountItemRowView(name: "Role", value: self.accountVM.role)
                            .foregroundColor(Color(UIColor.label))
                    }
                }
                Section(header: Text("Mailing Address")){
                    AccountItemRowView(name: "Adresse", value: self.accountVM.streetAddress)
                    AccountItemRowView(name: "Code Postal", value: String(self.accountVM.postalCode))
                    AccountItemRowView(name: "Ville", value: self.accountVM.city)
                    AccountItemRowView(name: "Téléphone", value: self.accountVM.phoneNumber)

                }
                
                
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .onAppear(perform: accountVM.load)
    }
    
    struct AccountItemRowView: View {
        @Environment(\.editMode) var editMode
        
        let name: String
        let value: String
        
        var body: some View {
            HStack {
                Text(name)
                Spacer()
                Text(value)
            }
        }
    }
}


extension View {
    func inputTextDialog(title: String, message: String, hintText: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping (String)->(), secondaryAction: @escaping ()->() ) {
        
        
        let alertC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertC.addTextField { filed in
            filed.placeholder = hintText
        }
        
        alertC.addAction(.init(title: secondaryTitle, style: .cancel, handler: { _ in
            secondaryAction()
        }))
        
        alertC.addAction(.init(title: primaryTitle, style: .default, handler: { _ in
            if let text = alertC.textFields?[0].text {
                primaryAction(text)
            }
            else {
                primaryAction("")
            }
        }))
        
        // MARK: Presenting Alert
        rootController().present(alertC, animated: true, completion: nil)
    }
    
    // MARK: Root View Controller
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
