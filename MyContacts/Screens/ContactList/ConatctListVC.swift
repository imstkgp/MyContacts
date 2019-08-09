//
//  ConatctListVC.swift
//  MyContacts
//
//  Created by mmt5885 on 08/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class ConatctListVC: UITableViewController {

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
        viewModel.fetchContactList()
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


extension ConatctListVC: ContactListDelegate {
    func refreshDetails() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
