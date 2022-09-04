//
//  MemberVM.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 03/09/2022.
//

import Foundation
import Firebase

class MemberVM: ObservableObject, Identifiable {
    
    let d: String = UUID().uuidString
    @Published var member: Member = .empty
    
    var isValide: Bool {
        !self.member.firstname.isEmpty &&
        !self.member.lastname.isEmpty &&
        !self.member.password.isEmpty &&
        !self.member.city.isEmpty &&
        !self.member.street.isEmpty
    }
    
    init(member: Member = .empty) {
        self.member = member
    }
    
    func update() -> Bool {
        var success = true
        let dbUserRef: DatabaseReference = {
            let dbname: String = try! Configuration.value(for:"MY_CLUB_DATABASE_NAME")
            let ref = Database.database()
                .reference()
                .child(dbname)
                .child("users")
                .child(self.member.id)
            return ref
        }()
        print(self.member.id)
        let dataDict = self.member.dictionary
        // 2
        dbUserRef.setValue(dataDict) { (error, ref) in
            if let error = error {
                success = false
                assertionFailure(error.localizedDescription)
                return
            }

            // 3
            DispatchQueue.main.async {
                dbUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        print(userDict.debugDescription)
                    }
                })
            }
        }
        return success
    }
}

extension MemberVM {
    func signUp(handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        AuthenticationService.signUp(email: self.member.email, password: self.member.password, handle: handle)
    }

    func signIn(handle:@escaping ((AuthDataResult?, Error?) -> Void)) {
        AuthenticationService.signIn(email: self.member.email, password: self.member.password, handle: handle)
    }
    
    func reset(callback: ((Error?) -> ())? = nil) {
        AuthenticationService.reset(withEmail: self.member.email)
    }
    
    func signOut(){
        AuthenticationService.signOut()
    }
}

extension MemberVM {
    
    // MARK: Validations Functions
    func passwordsMatch() -> Bool {
        return (self.member.password == self.member.repassword)
    }
    
    func isPasswordValid() -> Bool {
        return AuthViewModel.isPasswordValid(password: self.member.password)
    }
    
    func isRePasswordValid() -> Bool {
        return AuthViewModel.isPasswordValid(password: self.member.repassword)
    }
    
    func isEmailValid() -> Bool {
        // Criteria in regex. See http://regexlib.com
        //        Passwords to a length of 8 to 20 aplhanumeric characters and select special characters. The password also can not start with a digit, underscore or special character and must contain at least one digit.
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        
        return emailTest.evaluate(with: self.member.email)
    }
    
    func isPhoneValid() -> Bool {
        // Criteria in regex. See http://regexlib.com
        // Regex for French telephone numbers.
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", "^((\\+|00)33|0)*[1-9]([.-]*[0-9]{2}){4}$")
        
        return phoneTest.evaluate(with: self.member.phone)
    }
    
    func isPostalCodeValid() -> Bool {
        // Criteria in regex. See http://regexlib.com
        // Regex for French zip code.
        let postalCodeTest = NSPredicate(format: "SELF MATCHES %@", "^(([0-8][0-9])|(9[0-5])|(2[ab]))[0-9]{3}$")
        
        return postalCodeTest.evaluate(with: self.member.zipcode)
    }
    
    func isBirthDateValid() -> Bool {
        if self.member.birthDate == nil {
            return false
        }
        
        let today = Date()
        let seconds = today - (self.member.birthDate ?? Date())
        
        return seconds.asYears() > 13
    }
    
    func isFirstNameValid() -> Bool {
        return AuthViewModel.isNameValid(name: self.member.firstname)
    }
    
    func isLastNameValid() -> Bool {
        return AuthViewModel.isNameValid(name: self.member.lastname)
    }
    
    static func isNameValid(name: String) -> Bool {
        // Criteria in regex. See http://regexlib.com
        // This regex validates a persons first name. Acceptable names include compound names with a hyphen or a space in them.
        let nameTest = NSPredicate(format: "SELF MATCHES %@", "^([^ \\x21-\\x26\\x28-\\x2C\\x2E-\\x40\\x5B-\\x60\\x7B-\\xAC\\xAE-\\xBF\\xF7\\xFE]+){2,}$")
        
        return nameTest.evaluate(with: name)
    }
    
    static func isPasswordValid(password: String) -> Bool {
        // Criteria in regex. See http://regexlib.com
        //        Passwords to a length of 8 to 20 aplhanumeric characters and select special characters. The password also can not start with a digit, underscore or special character and must contain at least one digit.
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=[^\\d_].*?\\d)\\w(\\w|[!@#$%]){7,20}")
        
        return passwordTest.evaluate(with: password)
    }
    
    var isSignUpComplete: Bool {
        if !isPasswordValid() || !passwordsMatch() || !isEmailValid() {
            return false
        }
        return true
    }
    
    
    // MARK: - Validation Prompt Strings
    var confirmPwPrompt: String {
        if passwordsMatch() {
            return ""
        }
        else {
            return "Les champs de mot de passe ne correspondent pas"
        }
    }
    
    var birthDatePrompt: String {
        if isBirthDateValid() {
            return ""
        }
        else {
            return "Vous devez avoir au moins 13 ans pour créer votre propre compte"
        }
    }
    
    var fistNamePrompt: String {
        if isFirstNameValid() {
            return ""
        }
        else {
            return "Le prénom doit comporter au moins 3 caractères et est case-sensitive"
        }
    }
    
    var lastNamePrompt: String {
        if isLastNameValid() {
            return ""
        }
        else {
            return "Le nom de famille doit comporter au moins 3 caractères et est case-sensitive"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() {
            return ""
        }
        else {
            return "Entrez une adresse mail valide"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() {
            return ""
        }
        else {
            return "Doit comporter entre 8 et 20 caractères contenant au moins un chiffre, un caractère spécial et une majuscule"
        }
    }
    
    var passwordMatchPrompt: String {
        if passwordsMatch() {
            return ""
        }
        else {
            return "Les mots de passe doivent correspondre et avoir une longueur de 8 à 20 caractères, et doivent également contenir : au moins un chiffre, un caractère spécial et une lettre majuscule."
        }
    }
    
    var phonePrompt: String {
        if isPhoneValid() {
            return ""
        }
        else {
            return "Le numéro de téléphone doit être composé par 10 chiffres commencent par un 0"
        }
    }
    
    var postalCodePrompt: String {
        if isPostalCodeValid() {
            return ""
        }
        else {
            return "Le code postal n'est pas validé"
        }
    }
}
