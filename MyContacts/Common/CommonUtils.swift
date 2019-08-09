//
//  CommonUtils.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

final class CommonUtils {
    class func setupTranparentNavigation(forController controller: UIViewController) {
        controller.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        controller.navigationController?.navigationBar.shadowImage = UIImage()
        controller.navigationController?.navigationBar.isTranslucent = true
        controller.navigationController?.navigationBar.tintColor = Constant.appGreenColor
        controller.navigationController?.view.backgroundColor = .white
    }
    
    class func setupDefaultNavigation(forController controller: UIViewController) {
        controller.navigationController?.navigationBar.isTranslucent = false
        controller.navigationController?.navigationBar.tintColor = Constant.appGreenColor
        controller.navigationController?.view.backgroundColor = .white
    }
}
