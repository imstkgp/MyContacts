//
//  Validator.swift
//  MyContacts
//
//  Created by mmt5885 on 11/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

final class Validator {
    private class func isValidEmail(_ email:String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTestPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTestPredicate.evaluate(with: email)
    }
    
    private class func isValidPhoneNumber(_ number: String) -> Bool {
        let regex: String = "[2356789][0-9]{6}([0-9]{3})?"
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: number)
    }
    
    private class func isValidName(_ name: String) -> Bool {
        let chars = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ")
        if (name.trimmingCharacters(in: (CharacterSet.whitespacesAndNewlines)) == "") {
            return false
        }
        return (name.rangeOfCharacter(from: chars.inverted) == nil)
    }
    
    class func validate(email: String?) -> Bool {
        guard let email = email, email.count > 0 else {
             return false
        }
        if !isValidEmail(email) {
             return false
        }
        return true
    }
    
    class func validate(name:String?) -> Bool {
        guard let fName = name, fName.count > 0,  isValidName(fName) else {
            return false
        }
        if fName.count > 64 {
            return false
        }
        return true
    }
    
    class func validate(phoneNumber:String?) -> Bool {
        guard let phone = phoneNumber, phone.count > 0, isValidPhoneNumber(phone) else{
             return false
        }
        return true
    }
}
