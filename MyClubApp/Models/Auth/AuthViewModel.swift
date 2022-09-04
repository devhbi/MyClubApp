//
//  AuthViewModel.swift
//  MyClubApp
//
//  Created by Honoré BIZAGWIRA on 01/09/2022.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var username: String = ""
    @Published var date: Date?
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repassword: String = ""
    
    var birthDate: String {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd-MM-yyyy"

        // Convert Date to String
        return dateFormatter.string(from: self.date ?? Date())
    }
    
    // MARK: Validations Functions
    func passwordsMatch() -> Bool {
        return (self.password == self.repassword)
    }
    
    func isPasswordValid() -> Bool {
        return AuthViewModel.isPasswordValid(password: self.password)
    }
    
    func isRePasswordValid() -> Bool {
        return AuthViewModel.isPasswordValid(password: self.repassword)
    }
    
    func isEmailValid() -> Bool {
        // Criteria in regex. See http://regexlib.com
        //        Passwords to a length of 8 to 20 aplhanumeric characters and select special characters. The password also can not start with a digit, underscore or special character and must contain at least one digit.
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        
        return emailTest.evaluate(with: self.email)
    }
    
    func isUsernameValid() -> Bool {
        return AuthViewModel.isNameValid(name: self.username)
    }
    
    func isBirthDateValid() -> Bool {
        if self.date == nil {
            return false
        }
        
        let today = Date()
        let seconds = today - (self.date ?? Date())
        
        return seconds.asYears() > 13
    }
    
    func isFirstNameValid() -> Bool {
        return AuthViewModel.isNameValid(name: self.firstname)
    }
    
    func isLastNameValid() -> Bool {
        return AuthViewModel.isNameValid(name: self.lastname)
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
        if !isPasswordValid() || !passwordsMatch() || !isEmailValid() || !isUsernameValid() {
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
            return "Password fields do not match"
        }
    }
    
    var usernamePrompt: String {
        if isUsernameValid() {
            return ""
        }
        else {
            return "Username must be at least 3 characters long and is case-sensitive"
        }
    }
    
    var birthDatePrompt: String {
        if isBirthDateValid() {
            return ""
        }
        else {
            return "You must be at least 13 years old to create your own account"
        }
    }
    
    var fistNamePrompt: String {
        if isFirstNameValid() {
            return ""
        }
        else {
            return "First name must be at least 3 characters long and is case-sensitive"
        }
    }
    
    var lastNamePrompt: String {
        if isLastNameValid() {
            return ""
        }
        else {
            return "Last name must be at least 3 characters long and is case-sensitive"
        }
    }
    
    var emailPrompt: String {
        if isEmailValid() {
            return ""
        }
        else {
            return "Enter a valid email address"
        }
    }
    
    var passwordPrompt: String {
        if isPasswordValid() {
            return ""
        }
        else {
            return "Must be between 8 and 20 characters containing at least one number, one special character and one capital letter"
        }
    }
    
    var passwordMatchPrompt: String {
        if passwordsMatch() {
            return ""
        }
        else {
            return "Passwords must match and be 8-20 characters in length, and must also contain: at least one number, one special character and one capital letter."
        }
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension TimeInterval {
    func asMinutes() -> Double { return self / (60.0) }
    func asHours()   -> Double { return self / (60.0 * 60.0) }
    func asDays()    -> Double { return self / (60.0 * 60.0 * 24.0) }
    func asWeeks()   -> Double { return self / (60.0 * 60.0 * 24.0 * 7.0) }
    func asMonths()  -> Double { return self / (60.0 * 60.0 * 24.0 * 30.4369) }
    func asYears()   -> Double { return self / (60.0 * 60.0 * 24.0 * 365.2422) }
}
