//
//  EditContactVM.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

protocol EditContactDelegate {
    func updateContactDetails()
}

class AddOrEditContactVM {
    var delegate: EditContactDelegate?
    var contactData = [[String: String]]()
    
    func setupContactData(_ contact:Contact?) {
        self.contactData.removeAll()
        var mobile = ""
        var fname = ""
        var lname = ""
        var email = ""
        if let contact = contact {
            if let phoneNumber = contact.phoneNumber {
                mobile = phoneNumber
            }
            if let emailAddress = contact.email {
                email = emailAddress
            }
            fname = contact.firstName
            lname = contact.lastName
        }
        self.contactData.append(["name": "First Name", "value": fname, "placeholder": "e.g. Jhon"])
        self.contactData.append(["name": "Last Name", "value": lname, "placeholder": "e.g. Mathew"])
        self.contactData.append(["name": "mobile", "value": mobile, "placeholder": "e.g. 9876785645"])
        self.contactData.append(["name": "email", "value": email, "placeholder": "e.g. jhon@gmail.com"])
        self.delegate?.updateContactDetails()
    }
    
    func validateContactDetail() {
        
    }
}
