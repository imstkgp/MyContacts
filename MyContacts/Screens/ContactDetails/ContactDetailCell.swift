//
//  ContactDetailCell.swift
//  MyContacts
//
//  Created by mmt5885 on 10/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class ContactDetailCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    var type: ContactDetailType? {
        didSet {
            if let type = type {
                self.valueField.isUserInteractionEnabled = type != ContactDetailType.view
            }
        }
    }
    
    var invalidInput:Bool = false {
        didSet {
            if invalidInput {
                self.typeLabel?.textColor = .red
            } else {
                self.typeLabel?.textColor = .black
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
