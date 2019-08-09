//
//  EditContactVC.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class EditContactVC: UIViewController {

    @IBOutlet weak var profileInfoView: UIView! {
        didSet {
            self.profileInfoView.addGradientColor(
                withColors: [UIColor.white, Constant.appGreenColor],
                withStartPoint:  CGPoint.init(x: 0.5, y: 0),
                withEndPoint: CGPoint.init(x: 0.5, y: 1)
            )
        }
    }
    @IBOutlet weak var userImageView: AsyncImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 50
            self.userImageView.layer.borderColor = UIColor.white.cgColor
            self.userImageView.layer.borderWidth = 3
        }
    }

    @IBOutlet weak var userDetailTableView: UITableView!
    
    var contactDetail:Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cameraTapped() {
    }
    
    @IBAction func doneTapped() {
    }
    
    @IBAction func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
