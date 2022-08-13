//
//  TableViewCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 12.08.2022.
//

import UIKit

class UserTableCell: UITableViewCell {

    static let identifier = String(describing: UserTableCell.self)
    
    @IBOutlet private weak var profileImage: CustomImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    func configure(user: User) {
        profileImage.setImage(url: user.userImageUrl)
        usernameLabel.text = user.userName
    }

    
}
