//
//  NavigationCoordinator.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

final class NavigationCoordinator {
    private static let storyboard = UIStoryboard(name: "Main", bundle: nil)
    class func createContactDetailsController(_ contactDetail: Contact) -> ContactDetailVC {
        let controller = storyboard.instantiateViewController(withIdentifier: Constant.Controller.ContactDetailControllerID) as! ContactDetailVC
        controller.contact = contactDetail
        return controller
    }
    
    class func createEditContactController(_ contactDetail: Contact?) -> AddOrEditContactVC{
        let controller = storyboard.instantiateViewController(withIdentifier: Constant.Controller.ContactEditControllerID) as! AddOrEditContactVC
        controller.contactDetail = contactDetail
        return controller
    }
    
    class func push(from fromController: UIViewController, to toViewController:UIViewController) {
        fromController.navigationController?.pushViewController(toViewController, animated: true)
    }
    
    class func present(from fromController: UIViewController, to toViewController:UIViewController) {
        fromController.navigationController?.present(toViewController, animated: true, completion: nil)
    }
    
    class func pop(_ viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    class func dismiss(_ viewController: UIViewController) {
        viewController.navigationController?.dismiss(animated: true, completion: nil)
    }
}
