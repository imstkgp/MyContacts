//
//  HomeContactCell.swift
//  MyContacts
//
//  Created by mmt5885 on 09/08/19.
//  Copyright © 2019 Santosh Tewari. All rights reserved.
//

import UIKit

class HomeContactCell: UITableViewCell {

    @IBOutlet weak var userImageView: AsyncImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 20
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var favImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var model:Contact? {
        didSet {
            guard let model = model else {
                return
            }
            userNameLabel.text = model.fullName
            favImageView.isHidden = !model.favorite
            if let profileURL = model.profileURL, let url = URL.init(string: profileURL) {
                userImageView.load(url: url, defaultImage: #imageLiteral(resourceName: "placeholder_photo"))
            } else {
                userImageView.image = #imageLiteral(resourceName: "placeholder_photo")
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
