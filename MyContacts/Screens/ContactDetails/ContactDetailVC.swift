//
//  ContactDetailVC.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit
import MessageUI

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
    
    var contact:Contact?
    var viewModel: ContactDetailVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonUtils.setupTranparentNavigation(forController: self)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        setup()
    }
    
    func setup() {
        viewModel = ContactDetailVM()
        viewModel.delegate = self
        updateContactDetails(contact)
        fetchContactDetail()
    }
    
    func fetchContactDetail() {
        if let contactURL = contact?.url {
            viewModel.fetchContactDetails(forContactURL: contactURL)
        }
    }
    
    func updateContactDetails(_ contactDetail: Contact?) {
        guard let contactDetail = contactDetail else {
            return
        }
        userNameLabel.text = contactDetail.fullName
        if let url = URL.init(string: contactDetail.profileURL) {
            userImageView.load(url: url, defaultImage: #imageLiteral(resourceName: "placeholder_photo"))
        }
        self.favButton.isSelected = contactDetail.favorite
    }
    
    @objc func editTapped() {
        if let contactDetail = viewModel.contactDetail {
            NavigationCoordinator.present(from: self, to: NavigationCoordinator.createEditContactController(contactDetail))
        }
    }
    
    @IBAction func sendMessageTapped() {
        if let mobile = viewModel.mobile, MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [mobile]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func callTapped() {
        if let mobile = viewModel.mobile, let url = URL(string: "tel://\(mobile)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
        } else {
            // add error message here
        }
    }
    
    @IBAction func sendEmailTapped() {
        if MFMailComposeViewController.canSendMail(), let email = viewModel.email{
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    @IBAction func favouriteTapped() {
        let message = self.favButton.isSelected ? Constant.Message.removeFavourite : Constant.Message.addFavourite
        let alert = UIAlertController.alert(with: "", message: message, cancelButtonTitle: "Not Now", defaultButtonTitle: "Ok", cancelButtonAction: nil) { (action) in
            self.favButton.isSelected = !self.favButton.isSelected
            if let contactURL = self.contact?.url {
                self.viewModel.updateFavorite(forContactURL: contactURL, isFavourite: self.favButton.isSelected)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension ContactDetailVC: ContactDetailDelegate {
    func updateContactData() {
        DispatchQueue.main.async {
            self.updateContactDetails(self.viewModel.contactDetail)
            self.contactTableView.reloadData()
        }
    }
    
    func favoriteUpdateFailed() {
        DispatchQueue.main.async {
            let alert = UIAlertController.alertWithMessage(message: "Failed to mark contact as favourite")
            self.present(alert, animated: true, completion: nil)
            self.updateContactDetails(self.viewModel.contactDetail)
        }
    }
}

extension ContactDetailVC: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}

extension ContactDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contactData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactDetailCell.self), for: indexPath) as! ContactDetailCell
        cell.typeLabel.text = viewModel.contactType[indexPath.row]
        cell.valueField.text = viewModel.contactData[indexPath.row]
        cell.type = .view
        return cell
    }
}
