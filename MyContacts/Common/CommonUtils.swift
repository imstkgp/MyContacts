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
    
    class func showLoading(forController controller: UIViewController, message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        controller.present(alert, animated: true, completion: nil)
    }
    
    class func hideLoading(forController controller: UIViewController) {
        DispatchQueue.main.async {
            controller.dismiss(animated: false, completion: nil)
        }
    }
}
