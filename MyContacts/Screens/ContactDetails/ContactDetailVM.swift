//
//  ContactDetailVM.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

protocol ContactDetailDelegate {
    func updateContactData()
    func favoriteUpdateFailed()
}

class ContactDetailVM {
    var email:String?
    var mobile:String?

    var contactData = [String]()
    var contactType = [String]()
    var contactDetail: Contact?
    
    var delegate: ContactDetailDelegate?

    func fetchContactDetails(forContactURL contactURL:String?) {
        if let url = contactURL {
            APIManager.getContactDetail(contactUrl: url, complition: {[weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseContactResponse(result)
            })
        }
    }
    
    func updateFavorite(forContactURL contactURL:String?, isFavourite: Bool) {
        if let url = contactURL {
            var parameters = [String: Any]()
            parameters["favorite"] = isFavourite
            APIManager.updateContactDetail(contactUrl: url, parameters: parameters, complition: {[weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseContactResponse(result)
            })
        }
    }
    
    func parseContactResponse(_ result: Result<(Contact), Error>) {
        switch result {
        case .success(let contact):
            self.setupContactData(contact)
            break
        case .failure( _):
            self.delegate?.favoriteUpdateFailed()
            break
        }
    }

    func setupContactData(_ contact:Contact) {
        self.contactDetail = contact
        
        self.contactType.removeAll()
        self.contactData.removeAll()
        if let mobile = contact.phoneNumber {
            self.mobile = mobile
            self.contactType.append("mobile")
            self.contactData.append(mobile)
        }
        if let email = contact.email {
            self.email = email
            self.contactType.append("email")
            self.contactData.append(email)
        }
        self.delegate?.updateContactData()
    }
}
