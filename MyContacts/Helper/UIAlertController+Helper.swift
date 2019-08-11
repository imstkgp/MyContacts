//
//  UIAlertController+Helper.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func alertWithMessage(message:String, action:((UIAlertAction?)->Void)?) -> UIAlertController{
        let alert = UIAlertController.init(title: "", message: message, preferredStyle: .alert)
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: action))
        return alert
    }
    
    class func alert(with title:String, message:String, cancelButtonTitle:String, defaultButtonTitle:String, cancelButtonAction:((UIAlertAction?)->Void)?, defaultButtonAction:((UIAlertAction?)->Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: UIAlertAction.Style.cancel, handler: cancelButtonAction)
        alert.addAction(cancelAction)
        if !(defaultButtonTitle).isEmpty {
            let deafultAction = UIAlertAction(title: defaultButtonTitle, style: UIAlertAction.Style.default, handler: defaultButtonAction)
            alert.addAction(deafultAction)
        }
        return alert
    }
}
