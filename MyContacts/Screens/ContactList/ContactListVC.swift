//
//  ConatctListVC.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class ContactListVC: UITableViewController {

    lazy var errorView:ErrorView = {
        var errorView = ErrorView.instance(withMessage: Constant.Message.emptyContactList, showTryAgain: true)
        errorView.delegate = self
        errorView.frame = self.view.frame
        return errorView;
    }()
    
    var viewModel: ContactListVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonUtils.setupDefaultNavigation(forController: self)
    }

    func setup() {
        viewModel = ContactListVM()
        viewModel.delegate = self
        fetchContacts()
    }
    
    @IBAction func groupButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.alertWithMessage(message: "This feature is getting ready. Will be released soon.", action: nil)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addNewContact(_ sender: UIBarButtonItem) {
        self.viewModel.openAddContact(fromController: self)
    }
    
    func fetchContacts() {
        errorView.removeFromSuperview()
        CommonUtils.showLoading(forController: self, message: "Fetching contacts...")
        viewModel.fetchContactList()
    }
    
    func showErroView() {
        self.view.addSubview(errorView)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewModel.contactSectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let key = viewModel.contactSectionTitles[section]
        
        if let contacts = viewModel.contactDictionary[key] {
            return contacts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeContactCell.self), for: indexPath) as! HomeContactCell
        let key = viewModel.contactSectionTitles[indexPath.section]
        if let contacts = viewModel.contactDictionary[key] {
            cell.model = contacts[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.contactSectionTitles[section]
    }

    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.contactSectionTitles
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        viewModel.openContactDetails(forIndexPath: indexPath, fromController: self)
    }
}


extension ContactListVC: ContactListDelegate, ErrorViewDelegate, ContactUpdationProtocol {
    func refreshDetails() {
        CommonUtils.hideLoading(forController: self)
        DispatchQueue.main.async {
            if self.viewModel.contactList?.isEmpty ?? true {
                self.showErroView()
            }
            self.tableView.reloadData()
        }
    }
    
    func refreshIndexSet(indexSet: IndexSet) {
        self.tableView.beginUpdates()
        self.tableView.reloadSections(indexSet, with: .none)
        self.tableView.endUpdates()
    }
    func tryAgainTapped() {
        fetchContacts()
    }
    
    func onContactUpdatetionSucess(contact: Contact) {
        self.viewModel.addOrUpdateContactDetail(contact: contact)
    }
}
