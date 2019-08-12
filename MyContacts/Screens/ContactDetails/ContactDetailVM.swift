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
    var apiHelper: APIManager
    
    init(apiHelper: APIManager = .shared) {
        self.apiHelper = apiHelper
    }
    
    func fetchContactDetails(forId contactId:Int?) {
        if let contactId = contactId {
            apiHelper.getContactDetail(forId: contactId, complition: {[weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.parseContactResponse(result)
            })
        }
    }
    
    func updateFavorite(isFavourite: Bool) {
        if let contactDetail = contactDetail {
            var parameters = [String: Any]()
            parameters["favorite"] = isFavourite
            apiHelper.updateContactDetail(contactId: contactDetail.id, parameters: parameters, complition: {[weak self] (result) in
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
        if let mobile = contact.phoneNumber, !mobile.isEmpty {
            self.mobile = mobile
            self.contactType.append("mobile")
            self.contactData.append(mobile)
        }
        if let email = contact.email, !email.isEmpty {
            self.email = email
            self.contactType.append("email")
            self.contactData.append(email)
        }
        self.delegate?.updateContactData()
    }
}
