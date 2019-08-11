//
//  EditContactVM.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import Foundation

protocol AddOrEditContactDelegate {
    func updateContactDetails()
}

enum ContactInputType:String {
    case firstName, lastName, email, mobile
}

class AddOrEditContactVM {
    var delegate: AddOrEditContactDelegate?
    var contactData = [[String: String]]()
    var invalidInputs = [String]()
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
        
        #warning("Move to enum based logic")
        self.contactData.append(["name": "First Name", "key": "first_name", "value": fname, "placeholder": "e.g. Jhon", "type": ContactInputType.firstName.rawValue])
        self.contactData.append(["name": "Last Name", "key": "last_name", "value": lname, "placeholder": "e.g. Mathew", "type": ContactInputType.lastName.rawValue])
        self.contactData.append(["name": "mobile", "key": "phone_number", "value": mobile, "placeholder": "e.g. 9876785645", "type": ContactInputType.mobile.rawValue])
        self.contactData.append(["name": "email", "key": "favorite", "value": email, "placeholder": "e.g. jhon@gmail.com", "type": ContactInputType.email.rawValue])
        self.delegate?.updateContactDetails()
    }
    
    func saveContactData() {
        if (isValidContactDetail()) {
            var parameters = [String: Any]()
            for data in self.contactData {
                if let key = data["key"],
                    let value = data["value"] {
                    parameters[key] = value
                }
            }
            APIManager.createContactDetail(contactUrl: url, parameters: parameters, complition: {[weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseContactResponse(result)
            })
        } else {
            self.delegate?.updateContactDetails()
        }
        
    }
    
    func isValidContactDetail() -> Bool {
        invalidInputs.removeAll()
        for data in self.contactData {
            let value =  data["value"]
            if let type = data["type"],
                let inputType = ContactInputType.init(rawValue: type) {
                switch(inputType) {
                case .firstName, .lastName:
                    if (!Validator.validate(name: value)) {
                        invalidInputs.append(type)
                    }
                    break
                case .mobile:
                    if (!Validator.validate(phoneNumber: value)) {
                        invalidInputs.append(type)
                    }
                    break
                case .email:
                    if (!Validator.validate(email: value)) {
                        invalidInputs.append(type)
                    }
                    break
                }
            }
        }
        return invalidInputs.isEmpty
    }
}
