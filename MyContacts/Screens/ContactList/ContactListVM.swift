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
    func refreshIndexSet(indexSet: IndexSet)
}

final class ContactListVM {
    var contactDictionary = [String: [Contact]]()
    var contactSectionTitles = [String]()
    var contactList: [Contact]?
    var delegate:ContactListDelegate?
    var activeEditingIndex: IndexPath?
    var apiHelper: APIManager
    
    init(apiHelper: APIManager = .shared) {
        self.apiHelper = apiHelper
    }
    
    func fetchContactList() {
        apiHelper.getContactList(complition: {[weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.contactList?.removeAll()
            switch result {
            case .success(let contactList):
                strongSelf.contactList = contactList
                strongSelf.createContactDetails(contactList: contactList)
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
        
        for contactDetail in contactDictionary {
            contactDictionary[contactDetail.key] = contactDetail.value.sorted(by: <)
        }
        
        if !otherContacts.isEmpty {
            contactDictionary[Constant.otherContactKey] = otherContacts.sorted(by: <)
            contactSectionTitles.append(Constant.otherContactKey)
        }
    }
    
    func openContactDetails(forIndexPath indexPath:IndexPath, fromController controller:ContactListVC) {
        self.activeEditingIndex = indexPath
        let key = self.contactSectionTitles[indexPath.section]
        if let contacts = self.contactDictionary[key] {
            let contactDetailVC = NavigationCoordinator.createContactDetailsController(contacts[indexPath.row])
            contactDetailVC.delegate = controller
            NavigationCoordinator.push(from: controller, to: contactDetailVC)
        }
    }
    
    func openAddContact(fromController controller: ContactListVC) {
        let addContactController = NavigationCoordinator.createEditContactController(nil)
        addContactController.delegate = controller
        NavigationCoordinator.present(from: controller, to: addContactController)
    }
    
    func addOrUpdateContactDetail(contact:Contact) {
        var oldSection:Int? = nil
        let key = String(contact.firstName.prefix(1).uppercased())
        if var contactValues = contactDictionary[key] {
            if let index = contactValues.firstIndex(where: { (existingContact) -> Bool in
                return existingContact.id == contact.id
            }) {
                contactValues[index] = contact
            } else {
                if let activeIndex = self.activeEditingIndex {
                    self.removeCurrentItem(activeIndex);
                    oldSection = activeIndex.section
                }
                contactValues.append(contact)
            }
            contactDictionary[key] = contactValues.sorted(by: <)
        } else {
            if let activeIndex = self.activeEditingIndex {
                self.removeCurrentItem(activeIndex);
                oldSection = activeIndex.section
            }
            contactDictionary[key] = [contact]
        }
        var updatedIndexs = [Int]()
        if let newIndex = self.contactSectionTitles.firstIndex(of: key) {
            updatedIndexs.append(newIndex)
        }
        if let oldIndex = oldSection {
            updatedIndexs.append(oldIndex)
        }
        
        if !updatedIndexs.isEmpty {
            self.delegate?.refreshIndexSet(indexSet: IndexSet(updatedIndexs))
        }
        
    }
    
    func removeCurrentItem(_ activeIndex:IndexPath) {
        let key = self.contactSectionTitles[activeIndex.section]
        self.contactDictionary[key]?.remove(at: activeIndex.row)
        if self.contactDictionary[key]?.isEmpty ?? true {
            self.contactSectionTitles.remove(at: activeIndex.section)
        }
    }
}
