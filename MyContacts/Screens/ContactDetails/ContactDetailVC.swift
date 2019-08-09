//
//  ContactDetailVC.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class ContactDetailVC: UIViewController {

    @IBOutlet weak var userInfoView: UIView! {
        didSet {
            self.userInfoView.addGradientColor(
                withColors: [UIColor.white, Constant.appGreenColor],
                withStartPoint:  CGPoint.init(x: 0.5, y: 0),
                withEndPoint: CGPoint.init(x: 0.5, y: 1)
            )
        }
    }
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var userImageView: AsyncImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 50
            self.userImageView.layer.borderColor = UIColor.white.cgColor
            self.userImageView.layer.borderWidth = 3
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var contactDetail:Contact?
    
    var contactData = [String]()
    var contactType = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonUtils.setupTranparentNavigation(forController: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        setupContactDetails()
    }
    
    func setupContactDetails() {
        guard let contactDetail = self.contactDetail else {
            return
        }
        userNameLabel.text = contactDetail.fullName
        if let url = URL.init(string: contactDetail.profileURL) {
            userImageView.load(url: url, defaultImage: #imageLiteral(resourceName: "placeholder_photo"))
        }
        self.favButton.isSelected = contactDetail.favorite
        if let mobile = contactDetail.phoneNumber {
            contactType.append("mobile")
            contactData.append(mobile)
        }
        if let email = contactDetail.email {
            contactType.append("email")
            contactData.append(email)
        }
    }
    
    @objc func editTapped() {
        if let contactDetail = self.contactDetail {
        NavigationCoordinator.present(from: self, to: NavigationCoordinator.createEditContactController(contactDetail))
        }
    }
    
    @IBAction func sendMessageTapped(_ sender: Any) {
    }
    
    @IBAction func callTapped(_ sender: Any) {
    }
    
    @IBAction func sendEmailTapped(_ sender: Any) {
    }
    
    @IBAction func favouriteTapped(_ sender: Any) {
    }
}

extension ContactDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailCell.self), for: indexPath) as! ContactDetailCell
        cell.typeLabel.text = contactType[indexPath.row]
        cell.valueLabel.text = contactData[indexPath.row]
        return cell
    }
}
