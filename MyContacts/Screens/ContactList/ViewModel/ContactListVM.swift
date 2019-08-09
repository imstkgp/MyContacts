//
//  ContactListVM.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

protocol ContactListDelegate {
    func refreshDetails()
}

final class ContactListVM {
    var contactDictionary = [String: [Contact]]()
    var contactSectionTitles = [String]()
    var contactList: [Contact]?
    var delegate:ContactListDelegate?

    func fetchContactList() {
        APIManager.getContactList(complition: {[weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contactList?.removeAll()
            switch result {
            case .success(let contactList):
                strongSelf.contactList = contactList
                strongSelf.createContactDetails(contactList: contactList)
                print(contactList)
                break
            case .failure( _):
                break
            }
            strongSelf.delegate?.refreshDetails()
        })
    }
    
    private func createContactDetails(contactList: [Contact]) {
        var otherContacts = [Contact]()
        for contact in contactList {
            let key = String(contact.firstName.prefix(1).uppercased())
            if (!(key >= "A" && key <= "Z") || (key >= "a" && key <= "z")) {
                otherContacts.append(contact)
                continue
            }
            
            if var contactValues = contactDictionary[key] {
                contactValues.append(contact)
                contactDictionary[key] = contactValues
            } else {
                contactDictionary[key] = [contact]
            }
        }
        contactSectionTitles = [String](contactDictionary.keys)
        contactSectionTitles = contactSectionTitles.sorted(by: <)
        
        contactDictionary[Constant.otherContactKey] = otherContacts
        contactSectionTitles.append(Constant.otherContactKey)
    }
    
    func openContactDetails(forIndexPath indexPath:IndexPath, fromController controller:UIViewController) {
        let key = self.contactSectionTitles[indexPath.section]
        if let contacts = self.contactDictionary[key] {
            let contactDetailVC = NavigationCoordinator.createContactDetailsController(contacts[indexPath.row])
            NavigationCoordinator.push(from: controller, to: contactDetailVC)
        }
    }
}
