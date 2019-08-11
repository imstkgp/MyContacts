//
//  Constant.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

struct Constant {
    static let otherContactKey = "#"
    static let GRADIENT_LAYER_NAME = "gradient_layer"
    static let mobileNumberLength = 12
    static let appGreenColor = UIColor.init(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    struct URL {
        static let baseURL = "http://gojek-contacts-app.herokuapp.com/"
        static let contactDetailURL = "http://gojek-contacts-app.herokuapp.com/contacts/"
        static let contactsURL = "http://gojek-contacts-app.herokuapp.com/contacts.json"
    }
    
    struct Controller {
        static let ContactListControllerID = "ContactListVCID"
        static let ContactDetailControllerID = "ContactDetailVCID"
        static let ContactEditControllerID = "ContactEditVCID"
    }
    
    struct Message {
        static let addFavourite = "Add as a favourite contact."
        static let removeFavourite = "Remove from favourite contact."
        static let emptyContactList = "Failed to fetch contact list. Please try again in some time."
        static let genericErrorMessage = "Something went wrong. Please try again."
    }
}
