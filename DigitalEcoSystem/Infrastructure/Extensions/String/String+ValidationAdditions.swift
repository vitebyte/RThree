//
//  String+ValidationAdditions.swift
//  DigitalEcoSystem
//
//  Created by Shafi Ahmed on 08/03/17.
//  Copyright © 2017 Dean and Deluca. All rights reserved.
//

import Foundation

// MARK: - String Extension
extension String {
    /**
     Specify that string contains valid email address.

     - returns: A Bool return true if string has valid email otherwise false.
     */
    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    /**
     Specify that string contains valid phone number.

     - returns: A Bool return true if string has valid phone number otherwise false.
     */
    func isValidPhoneNumber() -> Bool {
        let phoneNumberFormat = "^\\d{2} \\d{4} \\d{4}$"
        let phoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberFormat)
        return phoneNumberPredicate.evaluate(with: self)
    }

    /**
     Specify that string contains valid password.

     - returns: A Bool return true if string has valid password otherwise false.
     */
    func isValidPassword() -> Bool {
        let passwordRegex = Constants.PASSWORD_REGEX
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let rVal = passwordTest.evaluate(with: self)
        return rVal
    }

    /**
     Specify that string contains valid web url.

     - returns: A Bool return true if it is valid url otherwise false.
     */
    func isValidUrl() -> Bool {
        let urlFormat = "((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: self)
    }

    /**
     Specify that string is empty or not.

     - returns: A Bool return true if string has value otherwise false.
     */
    func isNullOrEmpty() -> Bool {
        let optionalString: String? = self
        if optionalString == "(null)" || optionalString?.isEmpty == true {
            return true
        }
        return false
    }
}
