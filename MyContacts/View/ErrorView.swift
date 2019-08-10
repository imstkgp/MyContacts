//
//  ErrorView.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

protocol ErrorViewDelegate {
    func tryAgainTapped()
}
class ErrorView: UIView {
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var delegate:ErrorViewDelegate?
    
    @IBAction func tryAgainTapped() {
        self.delegate?.tryAgainTapped()
    }
    
    class func instance(withMessage message:String?, showTryAgain:Bool = false) -> ErrorView {
        let view = UINib(nibName: String(describing: ErrorView.self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ErrorView
        view.tryAgainButton.isHidden = !showTryAgain
        view.errorMessage.text = message
        return view
    }
}
